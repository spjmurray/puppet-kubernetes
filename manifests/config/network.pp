# == Class: kubernetes::config::network
#
# Install the necessary overlay network resources
#
class kubernetes::config::network {

  if $kubernetes::type == 'master' {

    File {
      owner => $kubernetes::user,
      group =>    $kubernetes::group,
    }

    $_overlay_prefix = $kubernetes::overlay_prefix
    $_flannel_target = "/home/${kubernetes::user}/kube-flannel.yml"

    file { $_flannel_target:
      ensure  => file,
      mode    => '0644',
      content =>  template('kubernetes/kube-flannel.yml.erb'),
    } ->
  
    exec { "/usr/bin/kubectl apply -f ${_flannel_target}":
      unless =>   '/usr/bin/kubectl get daemonset kube-flannel-ds -n kube-system',
    }

  }

}
