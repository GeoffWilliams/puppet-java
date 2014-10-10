# Test installing several Java versions alongside each other and removal
# of an outdated version.
#
# run with puppet apply --noop otherwise you will get failures due to 
# missing pacakges

java { ["jdk-1.7.0_65-fcs.x86_64.rpm", "jdk-1.7.0_67-fcs.x86_64.rpm"]:
  download_site => "http://172.16.1.101",
}

java { "jdk-1.7.0_62-fcs.x86_64.rpm":
  ensure => absent,
}
