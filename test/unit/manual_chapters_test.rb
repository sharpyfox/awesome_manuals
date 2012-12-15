require File.dirname(__FILE__) + '/../test_helper'

class ManualChapterTest < ActiveSupport::TestCase
	fixtures :manuals
  	fixtures :manual_chapters

  	#set the class to use for awesome_wiki_pages.yml
  	fixtures :awesome_wiki_pages
  	set_fixture_class :awesome_wiki_pages => WikiPage
	
  
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
 		page = awesome_wiki_pages(:wiki_pages_004)
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

 	def test_structure_import
 		chapter = manual_chapters(:some_chapter)
 		page = awesome_wiki_pages(:root_wiki_page)		

 		chapter.update_from_wiki_struct(page)

 		assert_equal page.id, chapter.wiki_page_id
 		assert_equal 3, chapter.children.count
 		assert_equal false, chapter.use_custom_title
 		assert_equal awesome_wiki_pages(:wiki_page_013).id, chapter.children[0].wiki_page_id
 		assert_equal false, chapter.children[0].use_custom_title
 		assert_equal awesome_wiki_pages(:wiki_page_014).id, chapter.children[1].wiki_page_id 		
 		assert_equal false, chapter.children[1].use_custom_title
 		assert_equal awesome_wiki_pages(:wiki_page_015).id, chapter.children[2].wiki_page_id
 		assert_equal false, chapter.children[2].use_custom_title
 		assert_equal awesome_wiki_pages(:wiki_page_016).id, chapter.children[1].children[0].wiki_page_id
 		assert_equal false, chapter.children[1].children[0].use_custom_title
 	end

 	def test_smart_structure_import
 		chapter = manual_chapters(:smarty_diff_chapter)
 		page = awesome_wiki_pages(:root_wiki_page)		

 		chapter.update_from_wiki_struct(page)

 		assert_equal page.id, chapter.wiki_page_id
 		assert_equal 3, chapter.children.count
 		assert_equal false, chapter.use_custom_title
 		assert_equal manual_chapters(:chapter_003).id, chapter.children[0].id
 		assert_equal awesome_wiki_pages(:wiki_page_013).id, chapter.children[0].wiki_page_id
 		assert_equal awesome_wiki_pages(:wiki_page_014).id, chapter.children[1].wiki_page_id 		
 		assert_equal false, chapter.children[1].use_custom_title
 		assert_equal awesome_wiki_pages(:wiki_page_015).id, chapter.children[2].wiki_page_id
 		assert_equal false, chapter.children[2].use_custom_title
 		assert_equal awesome_wiki_pages(:wiki_page_016).id, chapter.children[1].children[0].wiki_page_id
 		assert_equal false, chapter.children[1].children[0].use_custom_title
 	end

 	#service methods

 	def get_valid_manual
 		return  ManualChapter.new(:manual_id => 2)
 	end
end
