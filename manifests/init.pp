$username= "vagrant"
$home = "/home/${username}"

Exec { path => "${home}/bin:/usr/local/rbenv/bin:/usr/local/rbenv/shims::/usr/local/rbenv/shims/bin:/usr/bin:/bin:/usr/sbin:/sbin" }

exec { "set timezone":
  command => "/bin/echo 'America/Chicago' > /etc/timezone && /usr/sbin/dpkg-reconfigure -f noninteractive tzdata",
}

# --- Apt-get update ---------------------------------------------------------

exec { 'apt-update':
  command => "/usr/bin/apt-get update",
  onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}

Exec["apt-update"] -> Package <| |>

# --- Packages ---------------------------------------------------------------

package { ['curl', 'build-essential', 'vim', 'git-core', 'openssl', 'htop', 'imagemagick']:
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

#pg dependencies.
package { ['libpq-dev'] :
  ensure => installed
}

# --- Ruby -------------------------------------------------------------------

class { 'rbenv': }

rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::plugin { 'ianheggie/rbenv-binstubs': }
rbenv::plugin { 'sstephenson/rbenv-gem-rehash':
  before => Rbenv::Gem["bundler-2.1.2"]
}

rbenv::build { '2.1.2': global => true }

file { "${home}/bin":
  ensure => directory,
  owner => $username
}

file { "${home}/.bundle":
  ensure => directory,
  owner => $username
}

exec {"bundle install":
  command   => "bundle --binstubs=${home}/bin --path=${home}/.bundle",
  cwd       => "/vagrant",
  user      => $username,
  unless => "test 1 -eq `${home}/.rbenv/shims/bundle check | grep 'satisfied$' | wc -l`",
  timeout => 0,
  require => [Rbenv::Build["2.1.2"], File["${home}/bin"], File["${home}/.bundle"]]
}

Package <| |> -> Exec["bundle install"]

# --- Database -----------------------------------------------------------------

class { 'postgresql::server':
  postgres_password => 'password',
}

# --- SSH ----------------------------------------------------------------------

file { "${home}/.ssh":
  ensure => directory,
}

file { "${home}/.ssh/id_rsa":
  ensure  => present,
  mode    => 600,
  source  => "puppet:///ssh_files/id_rsa",
  require => File["${home}/.ssh"],
  owner   => $username
}

file { "${home}/.ssh/id_rsa.pub":
  ensure  => present,
  mode    => 644,
  source  => "puppet:///ssh_files/id_rsa.pub",
  require => File["${home}/.ssh"],
  owner   => $username
}

file { "${home}/.ssh/known_hosts":
  ensure  => present,
  mode    => 644,
  source  => "puppet:///ssh_files/known_hosts",
  require => File["${home}/.ssh"],
  owner   => $username,
  replace => "no"
}

file { "${home}/.bashrc":
  ensure => present,
  mode => 777,
  content => template(".bashrc.erb")
}

file { "${home}/.gitconfig":
  ensure => present,
  mode => 777,
  content => template(".gitconfig.erb")
}
