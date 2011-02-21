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

class FakeNameGenerator

  VERSION = '0.1.0'

  API_URL = 'http://svc.webservius.com/v1/CorbanWork/fakename'
  DEFAULT_OUTPUT = 'json'
  DEFAULT_COUNTRY = 'us'
  DEFAULT_NAMESET = 'us'
  DEFAULT_GENDER = '0' # random

  VALID_COUNTRY_CODES = %w( as au bg ca cyen cygk dk fi fr gr hu is it nl no pl sl sp sw sz uk us )
  VALID_NAMESET_CODES = %w( ar au ch dk en er fa fi fr gd gr hr hu ig is it jp jpja nl pl sl sp sw us vn zhtw )
  VALID_GENDER_CODES = %w(0 1 2)

  attr_reader :country,
    :nameset,
    :gender,
    :data
  attr_accessor :full_name,
    :first_name,
    :middle_name,
    :last_last,
    :maiden_name,
    :email_address,
    :street1

  def initialize(options={})
    @api_key = options[:api_key] or raise ArgumentError, "No API key provided"
    @country = options[:country] || DEFAULT_COUNTRY
    @nameset = options[:nameset] || DEFAULT_NAMESET
    @gender = options[:gender] || DEFAULT_GENDER

    raise ArgumentError, "Specified country parameter is not valid" unless VALID_COUNTRY_CODES.include?(@country)
    raise ArgumentError, "Specified nameset parameter is not valid" unless VALID_NAMESET_CODES.include?(@nameset)
    raise ArgumentError, "Specified gender parameter is not valid" unless VALID_GENDER_CODES.include?(@gender)

    url = [API_URL, build_params].join('?')
    response = Net::HTTP.get_response(URI.parse(url))
    #puts response.body
    @data = JSON.parse(response.body)
    build_name

  end

  private

  def build_params
    "wsvKey=#{@api_key}&output=#{DEFAULT_OUTPUT}&c=#{@country}&n=#{@nameset}&gen=#{@gender}"
  end

  def build_name
    @full_name   = data['identity']['full_name']['value']
    @first_name  = data['identity']['given_name']['value']
    @middle_name = data['identity']['middle_name']['value']
    @last_name   = data['identity']['surname']['value']
    @maiden_name = data['identity']['maiden_name']['value']
    @email_address = data['identity']['email_address']['value']
  end

end

