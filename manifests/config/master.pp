# == Class: kubernetes::config::master
#
# Initializes a kubernetes master node
#
class kubernetes::config::master {

  if $kubernetes::type == 'master' {

    File {
      owner => $kubernetes::user,
      group =>    $kubernetes::group,
    }

    $_argument_list = [
      "--token=${kubernetes::token}",
      "--apiserver-cert-extra-sans=${facts['ec2_metadata']['public-hostname']}",
      "--pod-network-cidr=${kubernetes::overlay_prefix}",
    ]

    $_arguments = join($_argument_list, " ")

    exec { "/usr/bin/kubeadm init ${_arguments}":
      creates => '/etc/kubernetes/admin.conf',
    } ->

    file { "/home/${kubernetes::user}/.kube":
      ensure => directory,
      mode   => '0755',
    } ->

    file { "/home/${kubernetes::user}/.kube/config":
      ensure => file,
      mode   => '0400',
      source => '/etc/kubernetes/admin.conf',
    }

  }

}
