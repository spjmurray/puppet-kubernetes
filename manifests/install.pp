# == Class: kubernetes::install
#
# Installs all necessary kubernetes/kubeadm prerequisites
#
class kubernetes::install {

  include ::apt

  Class['::apt::update'] -> Package <||>

  $packages = [
    'docker.io',
    'kubeadm',
    'kubectl',
    'kubelet',
  ]

  apt::source { 'kubernetes':
    location => 'http://apt.kubernetes.io/',
    release  => 'kubernetes-xenial',
    repos    => 'main',
    key      =>  {
      'id'     => 'D0BC747FD8CAF7117500D6FA3746C208A7317B0F',
      'source' =>  'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
    },
  }

  package { $packages: }

}
