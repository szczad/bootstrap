#!/usr/bin/env bash

NAME="etcd"
VERSION="${ETCD_VERSION:-"3.4.18"}"

install() {
  _etcd_tar="$(bootstrap_fetch "https://github.com/etcd-io/etcd/releases/download/v${VERSION}/etcd-v${VERSION}-${OS}-${ARCHN}.tar.gz")"
  _etcd_tmp="$(mktemp -d)"

  bootstrap_unpack -s "$_etcd_tar" "$_etcd_tmp"
  bootstrap_local_install "${_etcd_tmp}/etcd"
  bootstrap_local_install "${_etcd_tmp}/etcdctl"
}

