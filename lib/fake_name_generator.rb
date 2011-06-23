# fake_name_generator
#
# A FakeNameGenerator.com Ruby API Wrapper
#
# Author         : Bill Turner - http://brilliantcorners.org/
# Required       : FakeNameGenerator.com API Key - http://www.webservius.com/services/CorbanWork/fakename
# Source Repo    : http://github.com/billturner/fake_name_generator
# Gem Dependence : Net::HTTP, URI, json
# Ruby Version   : Written and tested using Ruby 1.8.7 and 1.9.2.
# License        : See LICENSE for details.

require 'net/http'
require 'uri'
require 'json'

# = Synopsis
# The fake_name_generator gem provides a simple wrapper to the 
# FakeNameGenerator.com API, which provides a randomized name,
# address information, as well as other indentifying information.
#
# == Example
#  require 'fake_name_generator'
#
#  fake_name = FakeNameGenerator.new(:api_key => 'VALID_API_KEY)
#  puts fake_name.full_name
#  puts fake_name.phone_number
#  puts fake_name.blood_type
#
# If you would like to receive non-US English results, you can 
# specify a country and nameset to use at the +new+ call:
#
#  fake_name = FakeNameGenerator.new(
#    :api_key => 'VALID_API_KEY',
#    :country => 'it',
#    :nameset => 'it')
#
# To see what options are available for country and nameset, see
# FakeNameGenerator::VALID_COUNTRY_CODES and 
# FakeNameGenerator::VALID_NAMESET_CODES, respectively.
#
# You can also specify the gender you would prefer in the resulting
# fake name. To do so, use the +:gender+ parameter:
#
#  fake_name = FakeNameGenerator.new(
#    :api_key => 'VALID_API_KEY',
#    :gender => '1')
#
# Where '0' is random, '1' is male, and '2' is female.
class FakeNameGenerator

  ##
  # The current version of the gem
  VERSION = '0.0.2'

  ##
  # The current FakeNameGenerator.com API endpoint
  API_URL = 'http://svc.webservius.com/v1/CorbanWork/fakename'
  DEFAULT_OUTPUT = 'json'
  DEFAULT_COUNTRY = 'us'
  DEFAULT_NAMESET = 'us'
  DEFAULT_GENDER = '0' # random
  
  ##
  # The currently valid country codes you can use
  VALID_COUNTRY_CODES = ['as', 'au', 'bg', 'ca', 'cyen', 'cygk', 'dk', 'fi', 'fr', 'gr', 'hu', 'is', 'it', 'nl', 'no', 'pl', 'sl', 'sp', 'sw', 'sz', 'uk', 'us']
  ##
  # The currently valid nameset codes you can use
  VALID_NAMESET_CODES = [ 'ar', 'au', 'ch', 'dk', 'en', 'er', 'fa', 'fi', 'fr', 'gd', 'gr', 'hr', 'hu', 'ig', 'is', 'it', 'jp', 'jpja', 'nl', 'pl', 'sl', 'sp', 'sw', 'us', 'vn', 'zhtw']
  ##
  # The currently valid gender codes you can use
  # 0 = random
  # 1 = male
  # 2 = female
  VALID_GENDER_CODES = ['0', '1', '2']

  class APIConnectionError < StandardError; end
  class APIKeyInvalidError < StandardError; end

  attr_reader :country, :data, :gender, :nameset

  # === Parameters
  # * _api_key_ = API key for accessing the FakeNameGenerator.com API (required)
  # * _country_ = country-related values returned (default: 'us')
  # * _nameset_ = language-related names returned (default: 'us')
  # * _gender_ = specify whether random, male, or female values returned (default: random)
  def initialize(options={})
    options[:api_key] || options[:json_data] or raise ArgumentError, "No API key or JSON data provided"
    @api_key = options[:api_key]
    @country = options[:country] || DEFAULT_COUNTRY
    @nameset = options[:nameset] || DEFAULT_NAMESET
    @gender = options[:gender] || DEFAULT_GENDER

    raise ArgumentError, "Specified country parameter is not valid. Please see FakeNameGenerator::VALID_COUNTRY_CODES" unless VALID_COUNTRY_CODES.include?(@country)
    raise ArgumentError, "Specified nameset parameter is not valid. Please see FakeNameGenerator::VALID_NAMESET_CODES" unless VALID_NAMESET_CODES.include?(@nameset)
    raise ArgumentError, "Specified gender parameter is not valid. Please see FakeNameGenerator::VALID_GENDER_CODES" unless VALID_GENDER_CODES.include?(@gender)

    if options[:json_data]
      @data = JSON.parse(options[:json_data])
    else
      url = [API_URL, build_params].join('?')
      response = Net::HTTP.get_response(URI.parse(url))

      case response.code
      when '500' || 500
        raise APIConnectionError, "FakeNameGenerator API not working (500 Error)"
      when '403' || 403
        raise APIKeyInvalidError, "Provided API key is not valid (403 Error)"
      when '200' || 200
        @data = JSON.parse(response.body)
      else
        raise StandardError, "Unexpected response from FakeNameGenerator.com API"
      end
    end
  end

  ##
  # Return the current fake name attributes as JSON
  def to_json
    @data.to_json
  end

  private

  def build_params
    "wsvKey=#{@api_key}&output=#{DEFAULT_OUTPUT}&c=#{@country}&n=#{@nameset}&gen=#{@gender}"
  end

  METHOD_ALIASES = {
    :gender_name => :gender,
    :first_name => :given_name,
    :last_name => :surname
  }

  def method_missing(sym)
    if data['identity'][sym.to_s]
      data['identity'][sym.to_s]['value']
    elsif METHOD_ALIASES[sym]
      data['identity'][METHOD_ALIASES[sym].to_s]['value']
    else
      raise NoMethodError, "undefined method \`#{sym}' for #{self}"
    end
  end
end

