#!/bin/bash
set -e

current_dir=$(realpath "$(dirname "$0")")
repo_array=("20.03-LTS" "20.03-LTS-SP1" "20.03-LTS-SP2" "20.03-LTS-SP3" "20.03-LTS-SP4" "20.09" "21.03" "21.09" "22.03-LTS" "22.03-LTS-SP1" "22.03-LTS-SP2" "22.03-LTS-SP3" "22.09" "23.03" "23.09")
if [ $# -ne 3 ]
then
        echo Usage: basic_image_build.sh version arch imagename
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
buildroot=/var/tmp/containers/$directoryname/$imagename

# put repos here
mkdir -p "${buildroot}"/etc/yum.repos.d/
touch "${buildroot}"/etc/yum.repos.d/openEulerOS.repo
cat>"${buildroot}"/etc/yum.repos.d/openEulerOS.repo<<EOF
[main]
gpgcheck=0
installonly_limit=3
clean_requirements_on_remove=True
best=True
skip_if_unavailable=False

[everything]
name=everything
baseurl=https://repo.huaweicloud.com/openeuler/openEuler-${version}/everything/${arch}/
enabled=1
gpgcheck=0
EOF

# install yum procps-ng rootfiles tar vim-minimal openEuler-release
dnf -y --installroot="$buildroot" --setopt=install_weak_deps=False --best --nodocs install yum procps-ng rootfiles tar vim-minimal openEuler-release
dnf -y --installroot="$buildroot" clean all

# remove packages dependencies
[ -d "${buildroot:?}"/var/lib/dnf ] && rm -rf "${buildroot:?}"/var/lib/dnf/*
[ -d "${buildroot:?}"/var/lib/rpm ] && rm -rf "${buildroot:?}"/var/lib/rpm/__db.*

# remove boot
rm -rf "${buildroot:?}"/boot

# only keep en_US locale
pushd "${buildroot:?}"/usr/lib/locale;rm -rf $(ls | grep -v en_US | grep -vw C.utf8 );popd
rm -rf "${buildroot:?}"/usr/share/locale/*

# remove man pages and documentation
rm -rf "${buildroot:?}"/usr/share/{man,doc,info,mime}

# remove ldconfig/dnf cache and log
rm -rf "${buildroot:?}"/etc/ld.so.cache
[ -d "${buildroot:?}"/var/cache/ldconfig ] && rm -rf "${buildroot:?}"/var/cache/ldconfig/*
[ -d "${buildroot:?}"/var/cache/dnf ] && rm -rf "${buildroot:?}"/var/cache/dnf/*
[ -d "${buildroot:?}"/var/log ] && rm -rf "${buildroot:?}"/var/log/*.log

# remove repo we used to install rpms
rm -f "${buildroot:?}"/etc/yum.repos.d/openEulerOS.repo

# compress it
OUTPUTIMG="$imagename".img.xz
tar -J -C "$buildroot" -c . -f "$OUTPUTIMG"
