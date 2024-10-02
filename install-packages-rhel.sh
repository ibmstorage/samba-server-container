#!/bin/bash

set -ex

# Assorted packages that must be installed in the container image to
# support the functioning of the container
support_packages=(\
    findutils \
    python-pip \
    python3-samba \
    python3-pyxattr \
    tdb-tools)

# Packages belonging to the samba install. If a samba_version_suffix is given
# all the samba_packages must share that version
samba_packages=(\
    samba \
    samba-client \
    samba-winbind \
    samba-winbind-clients \
    samba-vfs-iouring \
    samba-vfs-cephfs \
    libcephfs-proxy2 \
    ctdb \
    ctdb-ceph-mutex)

# Assign version suffix to samba packages
samba_versioned_packages=()
for p in "${samba_packages[@]}"; do
    samba_versioned_packages+=("${p}${SAMBA_VERSION_SUFFIX}")
done

subscription-manager register --activationkey=$(cat /run/secrets/activation-key) --org=$(cat /run/secrets/org-id)
subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms

dnf \
    install --setopt=install_weak_deps=False -y \
    "${support_packages[@]}" \
    "${samba_versioned_packages[@]}"

dnf clean all

cp --preserve=all /etc/ctdb/functions /usr/share/ctdb/functions
cp --preserve=all /etc/ctdb/notify.sh /usr/share/ctdb/notify.sh

subscription-manager unregister
