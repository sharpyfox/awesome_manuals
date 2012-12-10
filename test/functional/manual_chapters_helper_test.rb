require File.dirname(__FILE__) + '/../test_helper'
require 'manual_chapters_helper'

class ManualChaptersHelperTest < ActionController::TestCase
	include ManualChaptersHelper

	fixtures :manuals
  	fixtures :manual_chapters

  	#set the class to use for awesome_wiki_pages.yml
  	set_fixture_class :awesome_wiki_pages => WikiPage
	fixtures :awesome_wiki_pages
	fixtures :wikis

	def test_diff
		zResult = get_chapter_pages_intersect(manual_chapters(:diff_chapter), awesome_wiki_pages(:root_wiki_page))

		assert_equal [manual_chapters(:chapter_002)], zResult[:extraChapters]
		assert_equal [awesome_wiki_pages(:wiki_page_014), awesome_wiki_pages(:wiki_page_015)], zResult[:extraPages]
	end

	def test_diff_wrong_params
		zResult = get_chapter_pages_intersect(manual_chapters(:diff_chapter), nil)
		zCorrectResult = {:extraPages => [], :extraChapters => []}

		assert_equal zCorrectResult, zResult
	end

	SIMPLE_UL_TEXT = '<ul><li>Sample Text</li><li><ul><li>Sample Text</li><li>Sample Text</li></ul></li></ul>'
	EXTENDED_UL_TEXT = '<ul class="some_class"><li>Sample Text</li><li><ul><li>Sample Text</li><li>Sample Text</li></ul></li></ul>'
	WITHOUT_UL_TEXT = '<li>Sample Text</li><li><ul><li>Sample Text</li><li>Sample Text</li></ul></li>'

	def test_trim_root_ul
		assert_equal WITHOUT_UL_TEXT, trim_root_ul_tags(SIMPLE_UL_TEXT)
		assert_equal WITHOUT_UL_TEXT, trim_root_ul_tags(EXTENDED_UL_TEXT)
	end

	CLASSIFIED_AS_MISSING = '<ul><li class="missing-page">Sample Text</li><li class="missing-page"><ul><li class="missing-page">Sample Text</li><li class="missing-page">Sample Text</li></ul></li></ul>'

	def test_classify_as_missing
		assert_equal CLASSIFIED_AS_MISSING, classify_as_missing(SIMPLE_UL_TEXT)
	end

	def test_get_nested_missing_pages
		result = [awesome_wiki_pages(:root_wiki_page), awesome_wiki_pages(:wiki_page_014), awesome_wiki_pages(:wiki_page_015), awesome_wiki_pages(:wiki_page_016)].group_by(&:parent_id)
		assert_equal result, get_nested_missing_pages(awesome_wiki_pages(:root_wiki_page).id, [awesome_wiki_pages(:wiki_pages_001), awesome_wiki_pages(:wiki_pages_002),
			awesome_wiki_pages(:wiki_pages_004), awesome_wiki_pages(:wiki_pages_005), awesome_wiki_pages(:wiki_pages_006), awesome_wiki_pages(:wiki_pages_010), 
			awesome_wiki_pages(:wiki_pages_001), awesome_wiki_pages(:wiki_pages_011), awesome_wiki_pages(:wiki_page_013)])
	end

	def test_get_unknown_nested_missing_pages
		assert_equal [], get_nested_missing_pages(200, [])
	end

	def test_get_nested_missing_pages_witn_no_extra
		assert_not_equal [], get_nested_missing_pages(awesome_wiki_pages(:wiki_page_015).id, [])
	end
end
