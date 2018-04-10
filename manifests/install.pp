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

  # Expose dockerd via TCP
  # Todo: --tlsverify should be set, but pki makes life more complex
  file { '/etc/default/docker':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    content => "DOCKER_OPTS='-H tcp://0.0.0.0:${kubernetes::docker_port}' --tlsverify --tlscacert=${kubernetes::cacert} --tlscert=${kubernetes::cert} --tlskey=${kubernetes::key}",
  } ->

  package { $packages: }

}
