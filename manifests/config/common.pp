# == Class: kubernetes::config::commmon
#
# Performs common configuration across all nodes
#
class kubernetes::config::common {

  File {
    owner => $kubernetes::user,
    group =>   $kubernetes::group,
  }

  file { "/home/${kubernetes::user}/.kube":
    ensure => directory,
    mode   =>   '0755',
  } ->

  file { "/home/${kubernetes::user}/.kube/config":
    ensure => file,
    mode   => '0400',
    source =>   '/etc/kubernetes/admin.conf',
  }

}
