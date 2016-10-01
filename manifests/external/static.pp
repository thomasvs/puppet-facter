# = Define facter::external::static
#
# This define deploys custom external facts, in static files
#
# == Requirements:
#
# - This module requires facter
#
# == Parameters
#
# [* factsdotd *]
#   What directory to use for custom external facts
#   Default: /etc/facter/facts.d
#
# [* type *]
#   What type of file to deploy the facts in.  Currently only 'yaml' is
#   accepted.
#
# [* facts *]
#   A hash of fact key/value pairs
#
# == Examples
#
# facter::external::static { 'location':
#   facts => {
#     datacenter => 'linode',
#     country    => 'de',
#     platform   => 'production',
#   }
# }
#
# == Author
#  Thomas Vander Stichele <thomas (at) apestaart (dot) org>
#
define facter::external::static (
  $factsdotd='/etc/facter/facts.d',
  $type='yaml',
  $facts={}
) {

  include ::facter::external

  case $type {
    'yaml': {
      # use ruby to translate hash to yaml key/value pairs
      # works with ruby 1.8, not with ruby 1.9's Hash .join
      # http://stackoverflow.com/questions/3047007/flattening
      # we added sort to get consistent ordering, avoiding flipflops on every
      # run
      $content = inline_template(
        '---
<%= @facts.map{|e| e.join(\': \')}.sort().join(\'
\') %>'
      )

    }
    default: {
      fail("Unsupported fact type ${type}")
    }
  }

  file { "${factsdotd}/${name}.${type}":
    ensure  => file,
    content => $content,
    require => Class['facter::external'],
  }

}
