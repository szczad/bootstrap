#!/usr/bin/env bash

NAME="kvm"

enabled() {
  return $(is_true "${BOOTSTRAP_LIBVIRT_ENABLED:-"true"}")
}

install() {
  bootstrap_apt_install qemu-system-x86 libvirt-daemon-system libvirt-clients virt-manager bridge-utils
  bootstrap_group_add "kvm"
  bootstrap_group_add "libvirt"
}
