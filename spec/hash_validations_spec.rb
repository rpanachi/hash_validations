require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HashValidations" do

  it "Should initialize" do
    h = {}
    h.should be_valid
  end

  it "Should be valid for a empty hash" do
    h = {}
    h.should be_valid
  end

  describe "ValidatesPresenceOf" do

    it "Should be valid when hash has keys" do

      h = {:foo => "bar"}
      h.validates_presence_of :foo

      h.should be_valid
      
    end

    it "Should be invalid when hash not include keys" do

      h = {}
      h.validates_presence_of :foo

      h.should_not be_valid
      h.errors.should have_key(:foo)
      
    end

    it "Should return the message supplied for the validation when not pass" do
      h = {}
      h.validates_presence_of :foo, :message => "foo is required!"
      h.should_not be_valid
      h.errors.raw(:foo).first.should == "foo is required!"
    end

  end
end
