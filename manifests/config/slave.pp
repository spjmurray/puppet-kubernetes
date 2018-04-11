# == Class: kubernetes::config::slave
#
# Initializes a kubernetes slave node
#
class kubernetes::config::slave {

  if $kubernetes::type == 'slave' {

    $_argument_list = [
      "--token=${kubernetes::token}",
      "--discovery-token-unsafe-skip-ca-verification",
    ]

    $_arguments = join($_argument_list, " ")

    exec { "/usr/bin/kubeadm join ${_arguments} ${kubernetes::master}:${kubernetes::port}":
      creates => '/etc/kubernetes/admin.conf',
    }

  }

}
