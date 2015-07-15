# == Define: java
#
# Install Oracle java rpms on redhat systems.  Allows multiple versions to
# be installed alongside each other as well as the removal of specific
# versions.
#
# === Parameters
#
# [*namevar*]
#   The jdk .rpm filename to install.  You *must* rename the .rpm file
#   downloaded from Oracle to match it's declared package name which you
#   can determine by running rpm --info -qp against the downloaded file.
#   For example a downloaded jdk-7u67-linux-x64.rpm file should be renamed
#   to jdk-1.7.0_67-fcs.x86_64.rpm.  This step has to be done to allow puppet
#   to check if an rpm is already installed.  If you forget this step this 
#   module will attempt to warn you based on the current oracle .rpm naming
#   convention but this may change in the future.
#
# [*download_site*]
#   The location to download the .rpm file from.  You may download from 
#   sources supported by the nanliu-staging.  Currently:
#   * http(s)://
#   * puppet://
#   * ftp://
#   * s3:// (requires aws cli to be installed and configured.)
#   A download_site is required unless you are removing a package
#
# [*local_dir*]
#   Where to store downloaded .rpm files on the system.  All requested rpm
#   files will always downloaded and stored at all times so that they can
#   be installable with rpm at any time
#
# [*install_options*]
#   Extra arguments to pass to the rpm command.  This is typically used to
#   pass the --oldpackages option which allows older JDKs to be installed 
#   after newer ones.  Pass false to disable this or change to suit your
#   needs
#
# [*ensure*]
#   Ensure is passed to the puppet package resource if set.  You can pass
#   a value of absent to remove specific jdk(s) from the system.  By default
#   JDKs are set to ensure the requested package is present
#
# === Infrastructure requirements
# There must be a location available on the network to store the rpm files
# so that puppet can download them.  Support for this is provided by the 
# nanliu-staging module (https://forge.puppetlabs.com/nanliu/staging)
# e.g. you need one of:
# * http(s) server 
# * ftp server
# * Addional puppet fileserver (puppet:///...)
# * Amazon S3 location (untested - requires aws cli to be installed and 
#   configured.)
# Note that you should NOT host the rpms in a yum repository server to 
# prevent the "yum upgrade" command from attempting to automatically upgrade 
# older versions.
#
# A simple http server with a directory of RPMs is fine for this purpose
#
# === Workflow
# To install a new JDK, the following steps are required:
# (1) Go to http://java.oracle.com and download the jdk you want to install
# (2) Rename the downloaded rpm file to match its declared package name and 
#     version (check with rpm --info -qp).  Example:
#       mv jdk-7u67-linux-x64.rpm jdk-1.7.0_67-fcs.x86_64.rpm
# (3) Copy the renamed file to the server you will be downloading packages 
#     from.  Eg your rpm download http server's wwwroot directory
# (4) Check (with a browser/wget/curl) that you are able to download the new
#     file without error from wherever you copied it to.  eg:
#       wget http://172.16.1.101/jdk-1.7.0_67-fcs.x86_64.rpm
# (5) You may now refer to the new jdk in your puppet code
#
# === Examples
#
# Install jdk-1.7.0_65 and jdk-1.7.0_67 from an http server running on a
# server at http://172.16.1.101
#
#   java { ["jdk-1.7.0_65-fcs.x86_64.rpm", "jdk-1.7.0_67-fcs.x86_64.rpm"]:
#       download_site => "http://172.16.1.101",
#   }
#
# Uninstall a jdk package from the system
#   
#   java { "jdk-1.7.0_62-fcs.x86_64.rpm":
#       ensure => absent,
#   }
#
# === Authors
#
# Geoff Williams <geoff.williams@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#

define java($download_site = undef,
            $ensure = present,
            $local_dir = "/var/cache/java_rpms",
            $install_options = "--oldpackage") {

  if ( $::osfamily != "redhat" ) {
    fail("This Java module only supports the RedHat OS family")
  }

  $rpm_file = $title
  if ($rpm_file =~ /^jdk-\d+u\d+-linux-.*\.rpm$/) {
    fail("JDK .RPM files must be renamed to match the declared package eg mv jdk-7u67-linux-x64.rpm jdk-1.7.0_67-fcs.x86_64.rpm")
  }

  # need to tell the rpm provider the name of the PACKAGE which is the name of the
  # file with .rpm removed, otherwise it will attempt to reinstall it every time
  $rpm_name = regsubst($rpm_file, '\.rpm', '')
  $local_file   = "${local_dir}/${rpm_file}"
  $download_url = "${download_site}/${rpm_file}"
  if ($install_options) {
    $_install_options  = $install_options
  } else {
    # install options as passed to Package must be a string or hash...
    $_install_options = ""
  }

  if ($ensure == present) {
    if (! $download_site) {
      fail("must supply download_site if installing RPMs.  download_site is the location to download .rpm files from")
    }

    if (! defined(File[$local_dir])) {
      file { $local_dir:
        ensure => directory,
        owner  => "root",
        group  => "root",
        mode   => "0755",
      }
    }

    staging::file { $rpm_file:
      source => $download_url,
      target => $local_file,
    }

    $source_requirements = Staging::File[$rpm_file]
  } else {
    $source_requirements = []
  }

  package { $rpm_name:
    ensure          => $ensure,
    provider        => "rpm",
    source          => $local_file,
    install_options => $_install_options,
    require         => $source_requirements,
  }

  # create graph node so it can be monitored for events
  file { "/usr/java/latest": }
}
