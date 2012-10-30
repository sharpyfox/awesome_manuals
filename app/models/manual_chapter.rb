class ManualChapter < ActiveRecord::Base
	belongs_to :manual

	acts_as_nested_set#, :dependent => :destroy	

	#attr_accessible :parent_chapter_id

	after_save :update_nested_set_attributes

	validates_presence_of :manual
	
	def title		
		if use_custom_title
			return custom_title
		else
			@page = WikiPage.find_by_id(wiki_page_id)
			if (@page)
				@page.pretty_title
			else
				"Unknown"
			end
		end
	end

	def parent_chapter_id=(arg)
    	@parent_chapter_id = arg.blank? ? nil : arg.to_i    	
  	end

  	def parent_chapter_id
    	if parent
    		return parent.id
    	elsif @parent_chapter_id
    		return @parent_chapter_id
    	else
    		return nil
    	end
  	end

  	def possible_parents
		if manual 
			return manual.root.descendants - self_and_descendants
		else
			return []
		end
	end	

	def update_nested_set_attributes
		if !manual.manual_chapters.empty?
			update_parent

    		if (@parent_chapter) && move_possible?(@parent_chapter)
      			move_to_child_of(@parent_chapter)      			
      		end    	
      	end

    	return true
  	end

  private

  	def update_parent  		
  		@parent_chapter = nil

  		if !@parent_chapter_id  			
  			if manual.root
  				@parent_chapter = manual.root
  			end  			
  		else  			
  			@parent_chapter = ManualChapter.find_by_id(@parent_chapter_id)
  		end
  	end
end