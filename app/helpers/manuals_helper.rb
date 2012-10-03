require 'forwardable'
require 'cgi'

module ManualsHelper
  include ManualChaptersHelper

  def getContent(aPageId, aLevel)
    zResult = render(:partial => "wiki/content", :locals => {:content => @wiki_pages = WikiPage.find_by_id(aPageId).content_for_version(nil)})
    zResult = zResult.gsub(/(<a href="#).*(<\/a>)/){""}    
    zResult = zResult.gsub(/h4/){"h#{(aLevel + 4).to_s()}"}
    zResult = zResult.gsub(/h3/){"h#{(aLevel + 3).to_s()}"}
    zResult = zResult.gsub(/h2/){"h#{(aLevel + 2).to_s()}"}
    zResult = zResult.gsub(/h1/){"h#{(aLevel + 1).to_s()}"}
    zResult = zResult.gsub(/(<ul class="toc).*(<\/ul>)/){""}    
    zResult = zResult.gsub(/(src|href)="\//) { |s| "#{$1}=\"hthhtp://#{request.host_with_port}/" }
    zResult
  end

  def manual_structure(objects, &block)
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
            #output << '</li></ul>'
          end
          #output << '</li><li>'
        else
          path << o.parent_id
          #output << '<ul><li>'
        end
      elsif i != 0
        #output << '</li><li>'
      end
      output <<  "<h#{o.level}>" + o.title + "</h#{o.level}>" + "<br><br>" + getContent(o.wiki_page_id, o.level)
    end

    #output << '</li></ul>' * path.length
    output.html_safe
  end
end
