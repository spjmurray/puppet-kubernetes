# == Class: kubernetes::config
#
# Configures a kubernetes cluster with kubeadm
#
class kubernetes::config {

  File {
    owner => $kubernetes::user,
    group =>  $kubernetes::group,
  }

  $_kube_config = '/etc/kubernetes/admin.conf'

  exec { "/usr/bin/kubeadm init --pod-network-cidr=${kubernetes::overlay_prefix}":
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

  file { "/home/${kubernetes::user}/kube-flannel.yaml":
    ensure => file,
    mode   => '0644',
    source =>  'https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml',
  } ->

  exec { "/usr/bin/kubectl apply -f /home/${kubernetes::user}/kube-flannel.yaml":
    unless =>  '/usr/bin/kubectl get daemonset kube-flannel-ds -n kube-system',
  }

}

