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
  $_flannel_source = 'https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml'
  $_flannel_target_dir = "/home/${kubernetes::user}"
  $_flannel_target = "${_flannel_target_dir}/kube-flannel.yml"

  exec { "/usr/bin/kubeadm init --pod-network-cidr=${kubernetes::overlay_prefix} --apiserver-cert-extra-sans=${facts['ec2_metadata']['public-hostname']}":
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

  # Although 'file' supports http references, there is a bug where it doesn't
  # decompress the response body!
  exec { "/usr/bin/wget -q $_flannel_source":
    creates => $_flannel_target,
    cwd     => $_flannel_target_dir,
    user    => $kubernetes::user,
    group   => $kubernetes::group,
  } ->

  exec { "/usr/bin/kubectl apply -f ${_flannel_target}":
    unless =>  '/usr/bin/kubectl get daemonset kube-flannel-ds -n kube-system',
  } ->

  exec { '/usr/bin/kubectl taint nodes --all node-role.kubernetes.io/master-':
    # Todo: make idempotent
  }

}
