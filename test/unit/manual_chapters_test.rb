require File.dirname(__FILE__) + '/../test_helper'

class ManualChapterTest < ActiveSupport::TestCase
	fixtures :manual_chapters
	fixtures :wiki_pages
  
 	def test_manual_presence_validate
    	assert_equal false, ManualChapter.new(:manual_id => nil).valid?
    	assert_equal true, ManualChapter.new(:manual_id => 2).valid?
  	end

  	def test_custom_title
  		man = get_valid_manual
  		man.use_custom_title = true
  		man.custom_title = "custom"
  		assert_equal "custom", man.title
  	end

  	def test_wiki_title
  		man = get_valid_manual
  		page = wiki_pages(:wiki_pages_004)
  		man.wiki_page_id = 4
  		assert_equal page.pretty_title, man.title
  	end

  	def test_broken_wiki_title
  		man = get_valid_manual  		
  		man.wiki_page_id = -20
  		assert_equal "Unknown", man.title
  	end

  	def test_title_unknown
  		man = get_valid_manual
  		assert "Unknown", man.title
  	end

  	def test_possible_parents
  		chapter = manual_chapters(:first_second_chapter)  		
  		assert_equal 5, chapter.possible_parents.count
  	end

  	#service methods

  	# called before every single test
  	def setup
    	ManualChapter.rebuild!
  	end

  	def get_valid_manual
  		return  ManualChapter.new(:manual_id => 2)
  	end
end
