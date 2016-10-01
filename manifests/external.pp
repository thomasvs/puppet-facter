# = Class: facter::external
#
# This class sets up the necessary structure for custom external facts
#
# == Requirements:
#
# - This module requires facter
#
# == Author
#  Thomas Vander Stichele <thomas (at) apestaart (dot) org>
#
class facter::external {
  file { [ '/etc/facter', '/etc/facter/facts.d' ]:
    ensure => directory,
  }
}
