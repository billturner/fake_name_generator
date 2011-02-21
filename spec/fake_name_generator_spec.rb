require 'spec_helper'

describe FakeNameGenerator do

  describe "VERSION" do

    it "should have a version" do
      FakeNameGenerator::VERSION.should_not be_empty
    end

  end

  describe "runtime validations" do

    it "should fail if no API key was supplied" do
      lambda { fake = FakeNameGenerator.new }.should raise_error(ArgumentError)
    end

    it "should return object if API key was supplied" do
      fake = FakeNameGenerator.new(:api_key => 'VALID_API_KEY')
      fake.class.should == FakeNameGenerator
    end

    it "should use default parameters if none are specified" do
      @fake = FakeNameGenerator.new(:api_key => 'VALID_API_KEY')
      @fake.country.should == FakeNameGenerator::DEFAULT_COUNTRY
      @fake.nameset.should == FakeNameGenerator::DEFAULT_NAMESET
      @fake.gender.should == FakeNameGenerator::DEFAULT_GENDER
    end

    it "should use provided parameters if provided" do
      @fake = FakeNameGenerator.new(:api_key => 'VALID_API_KEY', :country => 'uk', :nameset => 'pl', :gender => '1')
      @fake.country.should == 'uk'
      @fake.nameset.should == 'pl'
      @fake.gender.should == '1'
    end

    it "should allow a valid option for country" do
      lambda { FakeNameGenerator.new(:api_key => 'VALID_API_KEY', :country => 'uk') }.should_not raise_error
    end

    it "should not allow an invalid option for country" do
      lambda { FakeNameGenerator.new(:api_key => 'VALID_API_KEY', :country => 'XXX') }.should raise_error(ArgumentError)
    end

    it "should allow a valid option for nameset" do
      lambda { FakeNameGenerator.new(:api_key => 'VALID_API_KEY', :nameset => 'pl') }.should_not raise_error
    end

    it "should not allow an invalid option for nameset" do
      lambda { FakeNameGenerator.new(:api_key => 'VALID_API_KEY', :nameset => 'XXX') }.should raise_error(ArgumentError)
    end

    it "should allow a valid option for gender" do
      lambda { FakeNameGenerator.new(:api_key => 'VALID_API_KEY', :gender => '2') }.should_not raise_error
    end

    it "should not allow an invalid option for gender" do
      lambda { FakeNameGenerator.new(:api_key => 'VALID_API_KEY', :gender => '3') }.should raise_error(ArgumentError)
    end

  end

  context "invalid api key" do

    it "should return a XXX status code" 

    it "should return an XML content type"

    it "should return an error string"

  end

  context "valid api key" do

    before do
      @fake = FakeNameGenerator.new(:api_key => 'VALID_API_KEY')
    end

    it "should return a XXX status code" 

    it "should return an XML content type"

    it "should return an error string"

    it "should fill in the name fields"

    it "should fill in the address fields"

    it "should fill in the credit card fields"

    it "should fill in the other random values"

  end

end

