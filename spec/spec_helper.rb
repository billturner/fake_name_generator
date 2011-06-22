$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'fakeweb'

require 'fake_name_generator'

fixtures = File.dirname(File.expand_path(__FILE__)) + "/fixtures"

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(:get, %r[http://svc\.webservius\.com/v1/CorbanWork/fakename\?(.*&|)wsvKey=VALID_API_KEY]i, :body => File.read("#{fixtures}/VALID_API_KEY.json"), :content_type => 'text/json', :status => ['200', 'OK'])
FakeWeb.register_uri(:get, %r[http://svc\.webservius\.com/v1/CorbanWork/fakename\?(.*&|)wsvKey=INVALID_API_KEY]i, :body => File.read("#{fixtures}/INVALID_API_KEY.xml"), :content_type => 'application/xml', :status => ["403", "Forbidden"])

RSpec.configure do |config|
end

