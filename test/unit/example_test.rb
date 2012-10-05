#-- encoding: UTF-8
require File.expand_path('../test_helper', File.dirname(__FILE__))

# Uses shoulda-context
class ExampleTest < Test::Unit::TestCase
  context "an example" do
    setup do
      @value = true
    end

    should "value should be true" do
      assert_equal true, @value
    end

    should "have some proper tests"
  end
end
