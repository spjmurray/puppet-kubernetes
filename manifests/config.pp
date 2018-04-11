# == Class: kubernetes::config
#
# Configures a kubernetes cluster with kubeadm
#
class kubernetes::config {

  contain ::kubernetes::config::master
  contain ::kubernetes::config::slave
  contain ::kubernetes::config::network

  Class['::kubernetes::config::master'] ->
  Class['::kubernetes::config::slave'] ->
  Class['::kubernetes::config::network']

}
