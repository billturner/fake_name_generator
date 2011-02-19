require 'spec_helper'

describe FakeNameGenerator do

  describe "VERSION" do

    it "should have a version" do
      FakeNameGenerator::VERSION.should_not be_blank
    end

  end

  describe "new" do

    it "should fail if no API key was supplied" do
      lambda { fake = FakeNameGenerator.new }.should raise_error(ArgumentError)
    end

    it "should return object if API key was supplied" do
      fake = FakeNameGenerator.new('123')
      fake.class.should == FakeNameGenerator
    end

  end

  describe "make_request" do

    before do
      @fake = FakeNameGenerator.new('123')
    end

    it "should use default parameters if none are specified" do
      @fake.make_request
      @fake.country.should == FakeNameGenerator::DEFAULT_COUNTRY
      @fake.nameset.should == FakeNameGenerator::DEFAULT_NAMESET
      @fake.gender.should == FakeNameGenerator::DEFAULT_GENDER
    end

    it "should use provided parameters if provided" do
      @fake.make_request(:country => 'uk', :nameset => 'pl', :gender => '1')
      @fake.country.should == 'uk'
      @fake.nameset.should == 'pl'
      @fake.gender.should == '1'
    end

    it "should allow a valid option for country" do
      lambda { @fake.make_request(:country => 'uk') }.should_not raise_error
    end

    it "should not allow an invalid option for country" do
      lambda { @fake.make_request(:country => 'XXX') }.should raise_error(ArgumentError)
    end

    it "should allow a valid option for nameset" do
      lambda { @fake.make_request(:nameset => 'pl') }.should_not raise_error
    end

    it "should not allow an invalid option for nameset" do
      lambda { @fake.make_request(:nameset => 'XXX') }.should raise_error(ArgumentError)
    end

    it "should allow a valid option for gender" do
      lambda { @fake.make_request(:gender => '2') }.should_not raise_error
    end

    it "should not allow an invalid option for gender" do
      lambda { @fake.make_request(:gender => '3') }.should raise_error(ArgumentError)
    end

  end

end

