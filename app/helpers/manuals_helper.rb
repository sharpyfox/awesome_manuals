require 'forwardable'
require 'cgi'

module ManualsHelper
  include ApplicationHelper
  include ManualChaptersHelper

  def getAttachment(aId)    
    zReturn = "data:none;base64,=="
    #return zReturn
    zAtt = Attachment.find_by_id(aId)
    if zAtt
      content_type = zAtt.content_type
      if content_type.blank?
        content_type = Redmine::MimeType.of(zAtt.filename)
      end
      
      #return zAtt.diskfile      
      return zAtt.diskfile.gsub(/JPG/){"png"}
    else
      return zReturn
    end
  end

  def removeToc(aTemplate)
    aTemplate.gsub(/(<ul.*?class="toc).*(<\/ul>)/){""}    
  end

  def replaceHeaders(aTemplate, aOffset, aIndex)
    zResult = aTemplate.gsub(/h4/){"h#{(aOffset + aIndex + 3).to_s()}"}
    zResult = zResult.gsub(/h3/){"h#{(aOffset + aIndex + 2).to_s()}"}
    zResult = zResult.gsub(/h2/){"h#{(aOffset + aIndex + 1).to_s()}"}
    return zResult.gsub(/h1/){"h#{(aOffset + aIndex).to_s()}"}
  end

  def replaceParagraphs(aTemplate)
    aTemplate.gsub(/<a.*?href=.*?\s*?.*?>&para;<\/a>/, "")
  end

  def replacePictures(aTemplate)    
    return aTemplate.gsub(/(<img.*?src=")\/.*?(\d*?)"/) { |s| "#{$1}#{getAttachment($2)}\"" }
  end

  def getContent(aChapter)    
    zWikiPage = WikiPage.find_by_id(aChapter.wiki_page_id)
    if zWikiPage      
      zResult = render(:partial => "wiki/content", :locals => {:content => @wiki_pages = WikiPage.find_by_id(aChapter.wiki_page_id).content_for_version(nil)})
      zResult = replaceParagraphs(zResult)
      zResult = replaceHeaders(zResult, aChapter.level, aChapter.use_custom_title ? 1 : 0)
      zResult = removeToc(zResult)
      zResult = replacePictures(zResult)
      zResult
    else
      ""
    end
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
          end          
        else
          path << o.parent_id
        end
      elsif i != 0        
      end

      if o.use_custom_title
        output <<  "<div class=\"wiki\"><h#{o.level}>" + o.title + "</h#{o.level}></div>"
      end
      if o.wiki_page_id
        output << getContent(o)
      end
    end
    
    output.html_safe
  end
end
