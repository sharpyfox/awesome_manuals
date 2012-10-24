require File.dirname(__FILE__) + '/../test_helper'
require 'manuals_helper'

class ManualsHelperTest < ActionController::TestCase
	include ManualsHelper

	PARAGRAPH_WITH_PREFIX = '<div><a some_attr="as" href="simple_href">&para;</a></div>'
	PARAGRAPH_STRING = '<div><a href="simple_href">&para;</a></div>'
	PARAGRAPH_WITH_SUFFIX = '<div><a href="simple_href" link="some">&para;</a></div>'

	def test_paragraphs
		assert_equal '<div></div>', replaceParagraphs(PARAGRAPH_WITH_PREFIX)
		assert_equal '<div></div>', replaceParagraphs(PARAGRAPH_STRING)
		assert_equal '<div></div>', replaceParagraphs(PARAGRAPH_WITH_SUFFIX)
	end

	HEADER_STRING = '<div><h1>asd</h1><h2>asd</h2><h3>asd</h3><h4>asd</h4></div>'
	OFFSET_HEADER_RESULT_STRING = '<div><h5>asd</h5><h6>asd</h6><h7>asd</h7><h8>asd</h8></div>'
	BIG_OFFSET_HEADER_RESULT_STRING = '<div><h6>asd</h6><h7>asd</h7><h8>asd</h8><h9>asd</h9></div>'

	def test_headers
		assert_equal OFFSET_HEADER_RESULT_STRING, replaceHeaders(HEADER_STRING, 5, 0)
		assert_equal BIG_OFFSET_HEADER_RESULT_STRING, replaceHeaders(HEADER_STRING, 5, 1)
	end

	CORRECT_TOC_STRING = '<div><ul id="asd" class="toc" attach="asd"><li>asdf</li></ul></div>'
	ANOTHER_CLASS_TOC_STRING = '<div><ul class="someclass"><li>asdf</li></ul></div>'
	WITHOUT_CLASS_TOC_STRING = '<div><ul><li>asdf</li></ul></div>'
	def test_toc_remove
		assert_equal '<div></div>', removeToc(CORRECT_TOC_STRING)
		assert_equal ANOTHER_CLASS_TOC_STRING, removeToc(ANOTHER_CLASS_TOC_STRING)
		assert_equal WITHOUT_CLASS_TOC_STRING, removeToc(WITHOUT_CLASS_TOC_STRING)
	end
end
