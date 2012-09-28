require 'forwardable'
require 'cgi'

module ManualsHelper
  include ManualChaptersHelper

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
      output <<  "<h#{o.level}>" + o.title + "</h#{o.level}>" + "<br>SomeContent here" * 50
    end

    #output << '</li></ul>' * path.length
    output.html_safe
  end
end
