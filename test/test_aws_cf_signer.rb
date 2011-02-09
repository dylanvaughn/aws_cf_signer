# -*- coding: utf-8 -*-
require 'helper'

class TestAwsCfSigner < Test::Unit::TestCase
  context "CloudFront Signing" do
    setup do
      @cf_signer = AwsCfSigner.new(File.join(File.dirname(__FILE__), 'fixtures', 'pk-PK123456789754.pem'))
    end

    context "Initialization and Error Checking" do
      should "be able to extract the key pair id from the filename of a key straight from AWS" do
        assert_equal @cf_signer.extract_key_pair_id('/path/to/my/key/pk-THEKEYID.pem'), 'THEKEYID'
      end

      should "be able to tell you the key pair id" do
        assert_equal @cf_signer.key_pair_id, 'PK123456789754'
      end

      should "be able to make a string 'Url-Safe'" do
        assert_equal(
          @cf_signer.url_safe("Test+String_~ =Something/Weird"),
          "Test-String_~_Something~Weird"
          )
      end
    end

    context "Example Canned Policy" do
      should "generate the correct signature" do
        assert_equal(
          @cf_signer.sign('http://d604721fxaaqy9.cloudfront.net/horizon.jpg?large=yes&license=yes', :ending => 'Sat, 14 Nov 2009 22:20:00 GMT'), 
          'http://d604721fxaaqy9.cloudfront.net/horizon.jpg?large=yes&license=yes&Expires=1258237200&Signature=Nql641NHEUkUaXQHZINK1FZ~SYeUSoBJMxjdgqrzIdzV2gyEXPDNv0pYdWJkflDKJ3xIu7lbwRpSkG98NBlgPi4ZJpRRnVX4kXAJK6tdNx6FucDB7OVqzcxkxHsGFd8VCG1BkC-Afh9~lOCMIYHIaiOB6~5jt9w2EOwi6sIIqrg_&Key-Pair-Id=PK123456789754'
          )
      end
    end

    context "Custom Policies from files" do
      should "generate custom policy 1 correctly" do
        assert_equal(
          @cf_signer.sign('http://d604721fxaaqy9.cloudfront.net/training/orientation.avi', :policy_file => File.join(File.dirname(__FILE__), 'fixtures', 'custom_policy1')), 
          'http://d604721fxaaqy9.cloudfront.net/training/orientation.avi?Policy=eyAKICAgIlN0YXRlbWVudCI6IFt7IAogICAgICAiUmVzb3VyY2UiOiJodHRwOi8vZDYwNDcyMWZ4YWFxeTkuY2xvdWRmcm9udC5uZXQvdHJhaW5pbmcvKiIsIAogICAgICAiQ29uZGl0aW9uIjp7IAogICAgICAgICAiSXBBZGRyZXNzIjp7IkFXUzpTb3VyY2VJcCI6IjE0NS4xNjguMTQzLjAvMjQifSwgCiAgICAgICAgICJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTI1ODIzNzIwMH0gICAgICAKICAgICAgfSAKICAgfV0gCn0K&Signature=cPFtRKvUfYNYmxek6ZNs6vgKEZP6G3Cb4cyVt~FjqbHOnMdxdT7eT6pYmhHYzuDsFH4Jpsctke2Ux6PCXcKxUcTIm8SO4b29~1QvhMl-CIojki3Hd3~Unxjw7Cpo1qRjtvrimW0DPZBZYHFZtiZXsaPt87yBP9GWnTQoaVysMxQ_&Key-Pair-Id=PK123456789754'
          )
      end

      should "generate custom policy 2 correctly" do
        assert_equal(
          @cf_signer.sign('http://d84l721fxaaqy9.cloudfront.net/downloads/pictures.tgz', :policy_file => File.join(File.dirname(__FILE__), 'fixtures', 'custom_policy2')), 
          'http://d84l721fxaaqy9.cloudfront.net/downloads/pictures.tgz?Policy=eyAKICAgIlN0YXRlbWVudCI6IFt7IAogICAgICAiUmVzb3VyY2UiOiJodHRwOi8vKiIsIAogICAgICAiQ29uZGl0aW9uIjp7IAogICAgICAgICAiSXBBZGRyZXNzIjp7IkFXUzpTb3VyY2VJcCI6IjIxNi45OC4zNS4xLzMyIn0sCiAgICAgICAgICJEYXRlR3JlYXRlclRoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTI0MTA3Mzc5MH0sCiAgICAgICAgICJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTI1NTY3NDcxNn0KICAgICAgfSAKICAgfV0gCn0K&Signature=rc~5Qbbm8EJXjUTQ6Cn0LAxR72g1DOPrTmdtfbWVVgQNw0q~KHUAmBa2Zv1Wjj8dDET4XSL~Myh44CLQdu4dOH~N9huH7QfPSR~O4tIOS1WWcP~2JmtVPoQyLlEc8YHRCuN3nVNZJ0m4EZcXXNAS-0x6Zco2SYx~hywTRxWR~5Q_&Key-Pair-Id=PK123456789754'
          )
      end
    end

    context "Custom Policy Generation" do
      should "correctly generate custom policy" do
        starting = Time.now
        ending   = Time.now + 3600
        ip_range = '216.98.35.1/32'
        assert_equal(
          @cf_signer.generate_custom_policy('http://d84l721fxaaqy9.cloudfront.net/downloads/*', :starting => starting, :ending => ending, :ip_range => ip_range),
          %({"Statement":[{"Resource":"http://d84l721fxaaqy9.cloudfront.net/downloads/*","Condition":{"DateLessThan":{"AWS:EpochTime":#{ending.to_i}},"DateGreaterThan":{"AWS:EpochTime":#{starting.to_i}},"IpAddress":{"AWS:SourceIp":"#{ip_range}"}}}]})
          )
      end

    end

  end
end
