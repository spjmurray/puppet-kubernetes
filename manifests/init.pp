# == Class: kubernetes
#
# Provisions a kubernetes cluster
#
# === Parameters
#
# [*type*]
#   Type of node to provision, either 'master' or 'slave'
#
# [*master*]
#   When creating a 'slave' connect to this master node to provision
#
# [*port*]
#   When creating a 'slave' connect to this kubernetes API port on the master node
#
# [*user*]
#   Local user account to use to install into
#
# [*group*]
#   Local group associated with the user parameter
#
# [*overlay_prefix*]
#   Prefix to assign to the overlay network
#
# [*docker_port*]
#   Port to expose dockerd on
#
# [*cacert*]
#   CA certificate for client authentication
#
# [*cert*]
#   Server certificate for authentication and encryption
#
# [*key*]
#   Server key for decryption
#
# [*token*]
#   Token used to join nodes to the cluster
#
class kubernetes (
  Enum['master', 'slave'] $type = 'master',
  String $master = '',
  Integer $port = 6443,
  String $user = 'ubuntu',
  String $group = 'ubuntu',
  String $overlay_prefix = '10.0.0.0/16',
  Integer $docker_port = 2376,
  String $cacert = '/etc/docker/ca.pem',
  String $cert = '/etc/docker/cert.pem',
  String $key = '/etc/docker/key.pem',
  String $token = 'd7022a.8a64f18120664947',
) {

  include ::kubernetes::install
  include ::kubernetes::config

  Class['::kubernetes::install'] ->
  Class['::kubernetes::config']

}
