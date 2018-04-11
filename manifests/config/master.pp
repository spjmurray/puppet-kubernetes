# == Class: kubernetes::config::master
#
# Initializes a kubernetes master node
#
class kubernetes::config::master {

  if $kubernetes::type == 'master' {

    $_argument_list = [
      "--token=${kubernetes::token}",
      "--apiserver-cert-extra-sans=${facts['ec2_metadata']['public-hostname']}",
      "--pod-network-cidr=${kubernetes::overlay_prefix}",
    ]

    $_arguments = join($_argument_list, " ")

    exec { "/usr/bin/kubeadm init ${_arguments}":
      creates => '/etc/kubernetes/admin.conf',
    }

  }

}
