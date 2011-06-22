$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'fakeweb'

require 'fake_name_generator'

FIXTURES = File.dirname(File.expand_path(__FILE__)) + "/fixtures"

def valid_api_body
  File.read("#{FIXTURES}/VALID_API_KEY.json")
end

def invalid_api_body
  File.read("#{FIXTURES}/INVALID_API_KEY.xml")
end

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(:get, %r[http://svc\.webservius\.com/v1/CorbanWork/fakename\?(.*&|)wsvKey=VALID_API_KEY]i, :body => valid_api_body, :content_type => 'text/json', :status => ['200', 'OK'])
FakeWeb.register_uri(:get, %r[http://svc\.webservius\.com/v1/CorbanWork/fakename\?(.*&|)wsvKey=INVALID_API_KEY]i, :body => invalid_api_body, :content_type => 'application/xml', :status => ["403", "Forbidden"])

RSpec.configure do |config|
end

