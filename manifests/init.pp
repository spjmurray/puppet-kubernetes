# == Class: kubernetes
#
# Provisions a kubernetes cluster
#
# === Parameters
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
class kubernetes (
  String $user = 'ubuntu',
  String $group = 'ubuntu',
  String $overlay_prefix = '10.0.0.0/16',
  Integer $docker_port = 2376,
  String $cacert = '/etc/docker/ca.pem',
  String $cert = '/etc/docker/cert.pem',
  String $key = '/etc/docker/key.pem',
) {

  include ::kubernetes::install
  include ::kubernetes::config

  Class['::kubernetes::install'] ->
  Class['::kubernetes::config']

}
