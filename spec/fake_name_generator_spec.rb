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

  #context "invalid api key" do

    ##it "should return an error" do
      ##lambda { FakeNameGenerator.new(:api_key => 'INVALID_API_KEY') }.should raise_error(FakeNameGenerator::APIKeyInvalidError)
    ##end

  #end

  describe "validly initialized" do

    shared_examples_for "a valid instance" do
      it "should fill in the name fields" do
        fake.full_name.should_not be_empty
        fake.first_name.should_not be_empty
        fake.middle_name.should_not be_empty
        fake.last_name.should_not be_empty
        fake.maiden_name.should_not be_empty
      end

      it "should fill in the address fields" do
        fake.street1.should_not be_empty
        fake.street2.should_not be_empty
        fake.city.should_not be_empty
        fake.state.should_not be_empty
        fake.zip.should_not be_empty
        fake.country_code.should_not be_empty
        fake.phone_number.should_not be_empty
      end

      it "should fill in the credit card fields" do
        fake.cc_type.should_not be_empty
        fake.cc_number.should_not be_empty
        fake.cc_exp_month.should_not be_nil
        fake.cc_exp_year.should_not be_nil
        fake.cc_cvv.should_not be_empty
      end

      it "should fill in the other random values" do
        fake.gender_name.should_not be_empty
        fake.birthday.should_not be_empty
        fake.occupation.should_not be_empty
        fake.password.should_not be_empty
        fake.domain.should_not be_empty
        fake.national_id.should_not be_empty
        fake.national_id_type.should_not be_empty
        fake.blood_type.should_not be_empty
        fake.weight_kilograms.should_not be_nil
        fake.weight_pounds.should_not be_nil
        fake.height_centimeters.should_not be_nil
        fake.height_inches.should_not be_nil
        fake.ups_tracking_number.should_not be_empty
      end

      it "should provide its data in JSON form when converted to_json" do
        fake.to_json.should == fake.data.to_json
      end
    end

    describe "from the web" do
      it_should_behave_like "a valid instance" do
        let(:fake) { FakeNameGenerator.new(:api_key => 'VALID_API_KEY') }
      end
    end

    describe "using JSON data" do
      it_should_behave_like "a valid instance" do
        let(:fake) { FakeNameGenerator.new(:json_data => valid_api_body) }
      end
    end

  end

end

