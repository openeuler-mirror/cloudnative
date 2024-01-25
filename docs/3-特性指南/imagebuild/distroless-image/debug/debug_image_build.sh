#!/bin/bash
set -e

current_dir=$(realpath "$(dirname "$0")")
repo_array=("20.03-LTS" "20.03-LTS-SP1" "20.03-LTS-SP2" "20.03-LTS-SP3" "20.03-LTS-SP4" "20.09" "21.03" "21.09" "22.03-LTS" "22.03-LTS-SP1" "22.03-LTS-SP2" "22.03-LTS-SP3" "22.09" "23.03" "23.09")
if [ $# -ne 3 ]
then
        echo Usage: base_image_build.sh version arch imagename
        exit 0
else
        # check if the repo version is valid
        if [[ "${repo_array[@]}" =~ $1 ]]; then
            version=$1
        else
                echo invalid repo version in openEuler
                exit 0
        fi
        # check if the arch is valid
        if [ $2 != "x86_64" ] && [ $2 != "aarch64" ]; then
                echo Support arch: x86_64 and aarch64
                exit 0
        else
                arch=$2
        fi
        imagename=$3
fi

directoryname=$(date +%Y%m%d)_$(date +%H%M%S)
buildroot=/var/tmp/containers/distroless/$directoryname/$imagename

# set repo here
rpmrepo=https://repo.huaweicloud.com/openeuler/openEuler-${version}/everything/${arch}/Packages/

# download necessary rpm package
wget -q -r -l1 -nd -A 'setup-[0-9]*.rpm' "${rpmrepo}" &> /dev/null
wget -q -r -l1 -nd -A 'filesystem-[0-9]*.rpm' "${rpmrepo}" &> /dev/null
wget -q -r -l1 -nd -A 'tzdata-[0-9]*.rpm' "${rpmrepo}" &> /dev/null
wget -q -r -l1 -nd -A 'ca-certificates-[0-9]*.rpm' "${rpmrepo}" &> /dev/null

# download rpm glibc openssl openssl-libs
wget -q -r -l1 -nd -A 'glibc-[0-9]*.rpm' "${rpmrepo}" &> /dev/null
wget -q -r -l1 -nd -A 'openssl-libs-[0-9]*.rpm' "${rpmrepo}" &> /dev/null
wget -q -r -l1 -nd -A 'openssl-[0-9]*.rpm' "${rpmrepo}" &> /dev/null

# download busybox
wget -q --no-check-certificate https://github.com/docker-library/busybox/raw/8822d69939aa6c41b50c66d0a4c5a5f8729f2178/stable/musl/busybox.tar.xz

# install filesystem tzdata ca-certificates setup
rpm -ih --nodeps --noscripts -r "${buildroot}" 'setup-[0-9]*.rpm'
rpm -ih --nodeps --noscripts -r "${buildroot}" 'filesystem-[0-9]*.rpm'
rpm -ih --nodeps --noscripts -r "${buildroot}" 'tzdata-[0-9]*.rpm'
rpm -ih --nodeps --noscripts -r "${buildroot}" 'ca-certificates-[0-9]*.rpm'
rpm -ih --nodeps --noscripts -r "${buildroot}" 'glibc-[0-9]*.rpm'
rpm -ih --nodeps --noscripts -r "${buildroot}" 'openssl-libs-[0-9]*.rpm'
rpm -ih --nodeps --noscripts -r "${buildroot}" 'openssl-[0-9]*.rpm'

# make busybox directory
mkdir "${buildroot}"/busybox
tar -xf busybox.tar.xz -C "${buildroot}"/busybox
mv "${buildroot}"/busybox/bin/busybox "${buildroot}"/busybox/
cd "${buildroot}"/busybox
for cmd in $(ls "${buildroot}"/busybox/bin)
do 
ln -s busybox "${buildroot}"/busybox/$cmd
done
rm -rf "${buildroot}"/busybox/bin "${buildroot}"/busybox/dev "${buildroot}"/busybox/etc "${buildroot}"/busybox/home 
rm -rf "${buildroot}"/busybox/root "${buildroot}"/busybox/tmp "${buildroot}"/busybox/usr "${buildroot}"/busybox/var

# add nonroot user's home 
mkdir "${buildroot}"/home/nonroot

# add nonroot user in /etc/passwd
cat >> ${buildroot:?}/etc/passwd << EOF
nonroot:x:65532:65532:nonroot:/home/nonroot:/sbin/nologin
EOF

# add nonroot entries in /etc/group
cat >> ${buildroot:?}/etc/group << EOF
nonroot:x:65532:
EOF

# modify home directory permission, owner and owner group of nonroot
groupadd -g 65532 nonroot
useradd nonroot -u 65532 -g nonroot
chmod 700 "${buildroot}"/home/nonroot
chown -R nonroot:nonroot "${buildroot}"/home/nonroot
userdel -r nonroot

# add os-release 
cat > "${buildroot:?}"/etc/os-release << EOF
NAME="openEuler"
VERSION="${version}"
ID="openEuler"ls
VERSION_ID="${version:0:5}"
PRETTY_NAME="openEuler-distroless ${version} ${arch}"
ANSI_COLOR="0;31"
EOF

# remove packages dependencies
[ -d "${buildroot:?}"/var/lib/dnf ] && rm -rf "${buildroot:?}"/var/lib/dnf/*
[ -d "${buildroot:?}"/var/lib/rpm ] && rm -rf "${buildroot:?}"/var/lib/rpm/*

# remove boot
rm -rf "${buildroot:?}"/boot

# only keep en_US locale
cd "${buildroot:?}"/usr/lib/locale;rm -rf $(ls | grep -v en_US | grep -vw C.utf8 )
rm -rf "${buildroot:?}"/usr/share/locale/*

# remove man pages and documentation
rm -rf "${buildroot:?}"/usr/share/{man,doc,info,mime}

# remove ldconfig cache and log
rm -rf "${buildroot:?}"/etc/ld.so.cache
[ -d "${buildroot:?}"/var/cache/ldconfig ] && rm -rf "${buildroot:?}"/var/cache/ldconfig/*
[ -d "${buildroot:?}"/var/log ] && rm -rf "${buildroot:?}"/var/log/*.log

# keep ca-certificates bep
rm -rf /etc/pki/ca-trust/extracted/java/cacerts /etc/pki/java/cacerts

# remove rpm file installed
rm -vf $current_dir/*.rpm
rm -vf $current_dir/*.tar.xz

# compress it
OUTPUTIMG="$imagename".img.xz
tar -J -C "$buildroot" -c . -f $current_dir/"$OUTPUTIMG"