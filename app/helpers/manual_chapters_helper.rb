require 'forwardable'
require 'cgi'

module ManualChaptersHelper
  include Redmine::WikiFormatting::Macros::Definitions
  include Redmine::I18n
  include GravatarHelper::PublicMethods

  extend Forwardable
  def_delegators :wiki_helper, :wikitoolbar_for, :heads_for_wiki_formatter

  def nested_li(objects, &block)
    objects = objects.order(:lft) if objects.is_a? Class

    return '' if objects.size == 0

    output = ''
    path = [nil]

    objects.each_with_index do |o, i|      
      if o.parent_id != path.last
        # We are on a new level, did we decend or ascend?
        if path.include?(o.parent_id)
          # Remove wrong wrong tailing paths elements
          while path.last != o.parent_id
            path.pop
            output << '</li></ul>'
          end
          output << '</li><li>'
        else
          path << o.parent_id
          output << '<ul><li>'
        end
      elsif i != 0
        output << '</li><li>'
      end
      output << link_to( o.title, o )
    end

    output << '</li></ul>' * (path.length - 1)
    output.html_safe
  end

  def intersect_list(objects)
    objects = objects.order(:lft) if objects.is_a? Class

    return '' if objects.size == 0

    output = ''
    path = [nil]
    extraChapters = []
    extraPages = []

    get_chapter_pages_intersect(objects.first.root, WikiPage.find_by_id(objects.first.root.wiki_page_id))[:extraChapters]

    objects.each_with_index do |o, i|
      if o.parent_id != path.last
        # We are on a new level, did we decend or ascend?
        if path.include?(o.parent_id)
          # Remove wrong wrong tailing paths elements
          while path.last != o.parent_id
            path.pop
            output << '</li></ul>'
          end
          output << '</li><li>'
        else
          path << o.parent_id
          output << '<ul><li>'          
        end
      elsif i != 0
        output << '</li><li>'
      end

      res = get_chapter_pages_intersect(o.parent, WikiPage.find_by_id(o.parent.wiki_page_id))
      extraChapters = res[:extraChapters]
      extraPages = res[:extraPages]

      if ((extraChapters.index(o)) || (o.wiki_page_id == nil))
        output << '<div class = "extra-chapter">' + link_to( o.title, o) + '</div>'
      else
        output << link_to( o.title, o)
      end

      if (o.children == [])
        nested = get_nested_missing_pages(o.wiki_page_id, extraPages)
        if (nested != [])
          output << render_some_page(nested, o.wiki_page_id)
        end
      end
    end

    output << '</li></ul>' * (path.length - 1)
    output.html_safe
  end

  def get_chapter_pages_intersect(aChapter, aWikiPage)    
    result = {:extraChapters => [], :extraPages => []}
    
    if !(aWikiPage)
      return result
    end

    @pages = WikiPage.find_all_by_parent_id(aWikiPage.id)

    aChapter.children.each do |child_chapter|
      if !(@pages.index{|x| x.id == child_chapter.wiki_page_id})
        result[:extraChapters] << child_chapter
      end
    end

    @pages.each do |child_page|
      if !(aChapter.children.index{|x| x.wiki_page_id == child_page.id})
        result[:extraPages] << child_page
      end
    end

    return result
  end

  def classify_as_missing(aTemplate)
    return aTemplate.gsub(/<li(.*?)>/) { |s| "<li class=\"missing-page\"#{$1}>" }
  end

  def trim_root_ul_tags(aTemplate)
    return aTemplate.gsub(/\A<ul(.*?)>|<\/ul>\z/, "")
  end

  def render_some_page(aPages, aPageId)
    return classify_as_missing(render_page_hierarchy(aPages, aPageId, :timestamp => true))
  end

  def get_nested_missing_pages(aParentId, aHandledList)
    page = WikiPage.find_by_id(aParentId)    
    if (page)
      if (aHandledList != [])
        cond = WikiPage.table_name + ".id NOT IN (#{aHandledList.map{|w| w.id}.join(',')})"
      else
        cond = ""
      end
      pages = page.wiki.pages.all(:order => 'title', :include => {:wiki => :project}, :conditions => cond)
      return pages.group_by(&:parent_id)
    else
      return []
    end
  end
end
