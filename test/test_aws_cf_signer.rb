# -*- coding: utf-8 -*-
require 'helper'

class TestAwsCfSigner < Test::Unit::TestCase
  context "CloudFront Signing" do
    setup do
      @cf_signer = AwsCfSigner.new(File.join(File.dirname(__FILE__), 'fixtures/pk-PK123456789754.pem'))
    end

    context "Initialization and Error Checking" do
      
      should "be able to extract the key pair id from the filename of a key straight from AWS" do
        assert_equal @cf_signer.extract_key_pair_id('/path/to/my/key/pk-THEKEYID.pem'), 'THEKEYID'
      end

      should "be able to tell you the key pair id" do
        assert_equal @cf_signer.key_pair_id, 'PK123456789754'
      end

      should "be able to make a string 'Url-Safe'" do
        assert_equal @cf_signer.url_safe("Test+String_~ =Something/Weird"), "Test-String_~_Something~Weird"
      end

    end

    context "Example Canned Policy" do

      should "generate the correct signature" do
        assert_equal @cf_signer.sign('http://d604721fxaaqy9.cloudfront.net/horizon.jpg?large=yes&license=yes', :until => 'Sat, 14 Nov 2009 22:20:00 GMT'), 'http://d604721fxaaqy9.cloudfront.net/horizon.jpg?large=yes&license=yes&Expires=1258237200&Signature=Nql641NHEUkUaXQHZINK1FZ~SYeUSoBJMxjdgqrzIdzV2gyEXPDNv0pYdWJkflDKJ3xIu7lbwRpSkG98NBlgPi4ZJpRRnVX4kXAJK6tdNx6FucDB7OVqzcxkxHsGFd8VCG1BkC-Afh9~lOCMIYHIaiOB6~5jt9w2EOwi6sIIqrg_&Key-Pair-Id=PK123456789754'
      end

    end

  end
end
