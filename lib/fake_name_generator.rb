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

  attr_reader :country,
    :nameset,
    :gender,
    :data,
    :full_name,
    :first_name,
    :middle_name,
    :last_name,
    :maiden_name,
    :email_address,
    :gender_name,
    :street1,
    :street2,
    :street3,
    :city,
    :state,
    :zip,
    :country_code,
    :phone_number,
    :birthday,
    :occupation,
    :password,
    :domain,
    :cc_type,
    :cc_number,
    :cc_exp_month,
    :cc_exp_year,
    :cc_cvv,
    :national_id,
    :national_id_type,
    :blood_type,
    :weight_kilograms,
    :weight_pounds,
    :height_centimeters,
    :height_inches,
    :ups_tracking_number

  # === Parameters
  # * _api_key_ = API key for accessing the FakeNameGenerator.com API (required)
  # * _country_ = country-related values returned (default: 'us')
  # * _nameset_ = language-related names returned (default: 'us')
  # * _gender_ = specify whether random, male, or female values returned (default: random)
  def initialize(options={})
    @api_key = options[:api_key] or raise ArgumentError, "No API key provided"
    @country = options[:country] || DEFAULT_COUNTRY
    @nameset = options[:nameset] || DEFAULT_NAMESET
    @gender = options[:gender] || DEFAULT_GENDER

    raise ArgumentError, "Specified country parameter is not valid. Please see FakeNameGenerator::VALID_COUNTRY_CODES" unless VALID_COUNTRY_CODES.include?(@country)
    raise ArgumentError, "Specified nameset parameter is not valid. Please see FakeNameGenerator::VALID_NAMESET_CODES" unless VALID_NAMESET_CODES.include?(@nameset)
    raise ArgumentError, "Specified gender parameter is not valid. Please see FakeNameGenerator::VALID_GENDER_CODES" unless VALID_GENDER_CODES.include?(@gender)

    url = [API_URL, build_params].join('?')
    response = Net::HTTP.get_response(URI.parse(url))

    case response.code
    when '500' || 500
      raise APIConnectionError, "FakeNameGenerator API not working (500 Error)"
    when '403' || 403
      raise APIKeyInvalidError, "Provided API key is not valid (403 Error)"
    when '200' || 200
      @data = JSON.parse(response.body)
      build_name
    else
      raise StandardError, "Unexpected response from FakeNameGenerator.com API"
    end

  end

  private

  def build_params
    "wsvKey=#{@api_key}&output=#{DEFAULT_OUTPUT}&c=#{@country}&n=#{@nameset}&gen=#{@gender}"
  end

  def build_name
    # name, gender info
    @gender_name              = data['identity']['gender']['value']
    @full_name                = data['identity']['full_name']['value']
    @first_name               = data['identity']['given_name']['value']
    @middle_name              = data['identity']['middle_name']['value']
    @last_name                = data['identity']['surname']['value']
    @maiden_name              = data['identity']['maiden_name']['value']
    @email_address            = data['identity']['email_address']['value']
    # street address
    @street1                  = data['identity']['street1']['value']
    @street2                  = data['identity']['street2']['value']
    @street3                  = data['identity']['street3']['value']
    @city                     = data['identity']['city']['value']
    @state                    = data['identity']['state']['value']
    @zip                      = data['identity']['zip']['value']
    @country_code             = data['identity']['country_code']['value']
    @phone_number             = data['identity']['phone_number']['value']
    # misc personal info
    @birthday                 = data['identity']['birthday']['value']
    @occupation               = data['identity']['occupation']['value']
    @password                 = data['identity']['password']['value']
    @domain                   = data['identity']['domain']['value']
    # credit card info
    @cc_type                  = data['identity']['cc_type']['value']
    @cc_number                = data['identity']['cc_number']['value']
    @cc_exp_month             = data['identity']['cc_exp_month']['value']
    @cc_exp_year              = data['identity']['cc_exp_year']['value']
    @cc_cvv                   = data['identity']['cc_cvv']['value']
    # identifying information
    @national_id              = data['identity']['national_id']['value']
    @national_id_type         = data['identity']['national_id_type']['value']
    @blood_type               = data['identity']['blood_type']['value']
    @weight_kilograms         = data['identity']['weight_kilograms']['value']
    @weight_pounds            = data['identity']['weight_pounds']['value']
    @height_centimeters       = data['identity']['height_centimeters']['value']
    @height_inches            = data['identity']['height_inches']['value']
    @ups_tracking_number      = data['identity']['ups_tracking_number']['value']

  end

end

