#!/bin/bash
set -e

current_dir=$(realpath "$(dirname "$0")")
repo_array=("20.03-LTS" "20.03-LTS-SP1" "20.03-LTS-SP2" "20.03-LTS-SP3" "20.09" "21.03" "21.09" "22.03-LTS" "22.03-LTS-SP1" "22.09")
if [ $# -ne 3 ]
then
        echo Usage: static_image_build.sh version arch imagename
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

# install filesystem tzdata ca-certificates setup
rpm -ivh --nodeps --noscripts -r "${buildroot}" 'setup-[0-9]*.rpm'
rpm -ivh --nodeps --noscripts -r "${buildroot}" 'filesystem-[0-9]*.rpm'
rpm -ivh --nodeps --noscripts -r "${buildroot}" 'tzdata-[0-9]*.rpm'
rpm -ivh --nodeps --noscripts -r "${buildroot}" 'ca-certificates-[0-9]*.rpm'

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
ID="openEuler"
VERSION_ID="${version:0:5}"
PRETTY_NAME="openEuler-distroless ${version} ${arch}"
ANSI_COLOR="0;31"
EOF

# remove packages dependencies
[ -d "${buildroot:?}"/var/lib/dnf ] && rm -rf "${buildroot:?}"/var/lib/dnf/*
[ -d "${buildroot:?}"/var/lib/rpm ] && rm -rf "${buildroot:?}"/var/lib/rpm/__db.*

# remove boot
rm -rf "${buildroot:?}"/boot

# remove man pages and documentation
rm -rf "${buildroot:?}"/usr/share/{man,doc,info,mime}

# remove ldconfig cache and log
rm -rf "${buildroot:?}"/etc/ld.so.cache
[ -d "${buildroot:?}"/var/cache/ldconfig ] && rm -rf "${buildroot:?}"/var/cache/ldconfig/*
[ -d "${buildroot:?}"/var/log ] && rm -rf "${buildroot:?}"/var/log/*.log

# remove rpm file installed
rm -vf *.rpm

# compress it
OUTPUTIMG="$imagename".img.xz
tar -J -C "$buildroot" -c . -f "$OUTPUTIMG"
