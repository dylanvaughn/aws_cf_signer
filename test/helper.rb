require 'bundler'
Bundler.require

require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'aws_cf_signer'

class Test::Unit::TestCase
end
