# == Class: kubernetes::config
#
# Configures a kubernetes cluster with kubeadm
#
class kubernetes::config {

  File {
    owner => $kubernetes::user,
    group =>  $kubernetes::group,
  }

  $_overlay_prefix = $kubernetes::overlay_prefix
  $_kube_config = '/etc/kubernetes/admin.conf'
  $_flannel_target = "/home/${kubernetes::user}/kube-flannel.yml"

  case $kubernetes::type {
    'master': {
      $_argument_list = [
        "--token=${kubernetes::token}",
        "--apiserver-cert-extra-sans=${facts['ec2_metadata']['public-hostname']}",
        "--pod-network-cidr=${_overlay_prefix}",
      ]

      $_arguments = join($_argument_list, " ")

      exec { "/usr/bin/kubeadm init ${_arguments}":
        creates =>  $_kube_config,
      } ->

      File["/home/${kubernetes::user}/.kube"]
    }

    'slave': {
      $_argument_list = [
        "--token=${kubernetes::token}",
        "--discovery-token-unsafe-skip-ca-verification",
      ]

      $_arguments = join($_argument_list, " ")

      exec { "/usr/bin/kubeadm join ${_arguments} ${kubernetes::master}:${kubernetes::port}":
        creates =>   $_kube_config,
      } ->

      File["/home/${kubernetes::user}/.kube"]
    }
  }

  file { "/home/${kubernetes::user}/.kube":
    ensure => directory,
    mode   =>  '0755',
  } ->

  file { "/home/${kubernetes::user}/.kube/config":
    ensure => file,
    mode   => '0400',
    source =>  '/etc/kubernetes/admin.conf',
  } ->

  file { $_flannel_target:
    ensure  => file,
    mode    => '0644',
    content => template('kubernetes/kube-flannel.yml.erb'),
  } ->

  exec { "/usr/bin/kubectl apply -f ${_flannel_target}":
    unless =>  '/usr/bin/kubectl get daemonset kube-flannel-ds -n kube-system',
  } ->

  exec { '/usr/bin/kubectl taint nodes --all node-role.kubernetes.io/master-':
    # Todo: make idempotent
  }

}
