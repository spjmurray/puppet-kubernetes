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

  exec { "/usr/bin/kubeadm init --pod-network-cidr=${_overlay_prefix} --apiserver-cert-extra-sans=${facts['ec2_metadata']['public-hostname']}":
    creates =>  $_kube_config,
  } ->

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
