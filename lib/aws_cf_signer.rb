require 'openssl'
require 'time'
require 'base64'

class AwsCfSigner

  attr_reader :key_pair_id

  def initialize(pem_path, key_pair_id = nil)
    @pem_path    = pem_path
    @key         = OpenSSL::PKey::RSA.new(File.readlines(@pem_path).join(""))
    @key_pair_id = key_pair_id ? key_pair_id : extract_key_pair_id(@pem_path)
    unless @key_pair_id
      raise ArgumentError.new("key_pair_id couldn't be inferred from #{@pem_path} - please pass in explicitly")
    end
  end

  def sign(url, policy_options = {})
    if policy_options[:until]
      expires_at = case policy_options[:until]
                   when String then Time.parse(policy_options[:until]).to_i
                   when Time   then policy_options[:until].to_i
                   else raise ArgumentError.new("Invalid 'until' argument' - String or Time required - #{policy_options[:until].class} passed.")
                   end
      policy     = %({"Statement":[{"Resource":"#{url}","Condition":{"DateLessThan":{"AWS:EpochTime":#{expires_at}}}}]})
      sig        = url_safe(Base64.encode64(@key.sign(OpenSSL::Digest::SHA1.new, (policy))))
      separator  = url =~ /\?/ ? '&' : '?'
      "#{url}#{separator}Expires=#{expires_at}&Signature=#{sig}&Key-Pair-Id=#{@key_pair_id}"
    else
      raise ArgumentError.new("'until' argument is required")
    end
  end

  def extract_key_pair_id(key_path)
    File.basename(key_path) =~ /^pk-(.*).pem$/ ? $1 : nil
  end

  def url_safe(s)
    s.gsub('+','-').gsub('=','_').gsub('/','~').gsub(/\n/,'').gsub(' ','')
  end

end
