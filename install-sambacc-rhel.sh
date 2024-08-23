dnf install -y python3-sambacc$SAMBACC_VERSION_SUFFIX
dnf clean all
container_json_file="/usr/local/share/sambacc/examples/minimal.json"

ln -sf "$container_json_file" /etc/samba/container.json
