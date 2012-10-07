require File.dirname(__FILE__) + '/../test_helper'

class ManualTest < ActiveSupport::TestCase
  fixtures :manuals

  def test_title_validate
    assert_equal false, Manual.new(:title => nil).valid?
    assert_equal true, Manual.new(:title => "some title").valid?
  end

  def test_auto_root_create
    Manual.any_instance.stubs(:valid?).returns(true)
    man = Manual.new(:title => "some title")    
    assert man.save!
    assert man.root # root node should be auto created
  end

  def test_auto_root_recreate
	man = manuals(:project_without_chapters)   
    assert man.root # if some goin wrong root node must be auto recreated
  end
end
