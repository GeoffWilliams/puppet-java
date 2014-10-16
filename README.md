# java
[![Build Status](https://travis-ci.org/GeoffWilliams/puppet-java.svg?branch=master)](https://travis-ci.org/GeoffWilliams/puppet-java)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with java](#setup)
    * [What java affects](#what-java-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Install Oracle Java from RPMs on redhat family OS

## Module Description

Downloads Java RPMs from a location on your network (using nanlui-staging) then
installs using the puppet RPM provider passing the --oldpackage option to allow
old packages to be installed alongside each other.

Requires a suitable location to download from

## Setup

### What java affects

* Installs the Java binaries at the location the RPM has packed them to install 
  to.  This is the /usr/java directory at time of writing
* The RPM files will be made available locally at the location passed by the 
  `local_dir` variable.  Defaults to `/var/cache/java_rpms`
* The RPM itself controls the value of the /usr/java/latest symlink

### Setup Requirements

* You must have a suitable location to download the RPMs from.  You are advised
  to NOT store the RPMs in a yum repository as the Oracle Java RPMs will not 
  allow different versions of Java to be installed at the same time if using 
  yum
* You must RENAME the RPM file downloaded from oracle to reflect its declared
  pacackage name.  See guidance in manifests/init.pp

## Usage

Install two versions of JDK alongside each other.  Supply a title array of 
versions to install (or have multiple java{...} declarations).  The module will
attempt to download these RPMs from wherever `download_site` is set to

    java { ["jdk-1.7.0_65-fcs.x86_64.rpm", "jdk-1.7.0_67-fcs.x86_64.rpm"]:
        download_site => "http://172.16.1.101",
    }

Uninstall a specific Java package from the system
    java { "jdk-1.7.0_62-fcs.x86_64.rpm":
        ensure => absent,
    }

## Reference

### manifests/init.pp 
Defined type `java` and comprehensive inline documentation

### tests/init.pp 
Smoke test for multiple versions and package removal

### spec/defines/java_spec.rb
Ruby rspec tests.  Run with `rake spec`  

## Limitations

Only supports RedHat OS family

