# == Class: java
#
# Full description of class java here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { java:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Geoff Williams <Geoff.Williams@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
define java($package_name = "jdk", $package_release = "fcs") {
   
    # sample i586 package name jdk-1.7.0_67-fcs.x86_64
    # sample x86_64 package name jdk-1.7.0_67-fcs.x86_64

    if ($::architecture != "x86_64") {
        fail("only x86_64 architecture supported -- see Australia Post Infrastructure Standard, Apache Tomcat, JDK binaries")
    }

    $full_version = "${title}-${package_release}"

    package { "${package_name}-${title}":
        name   => $package_name,
        ensure => $full_version,
    }

}
