class ManualChaptersController < ApplicationController
	unloadable
		
	before_filter :fetch_wiki_pages
	before_filter :find_chapter, :only => [:show, :edit, :import, :intersect, :update, :reorder, :update_from_wiki, :destroy]
  
	def new
		new_common_part
	end

	def new_from_wiki
		new_common_part
		@new_chapter_url = create_chapter_from_wiki_path(@manual)
		render :template => "manual_chapters/import"
	end
  
	def create
		create_common_part()
		if @chapter.save
			flash[:notice] = "Successfully created chapter."
			redirect_to manual_chapter_url(@chapter)
		else
			render :action => 'new'
		end
	end

	def create_from_wiki
		create_common_part()
		@page = WikiPage.find(params[:manual_chapter][:wiki_page_id])
		if @chapter.save
			@chapter.update_from_wiki_struct(@page)
			flash[:notice] = "Successfully created chapter."
			redirect_to manual_chapter_url(@chapter)
		else
			render :action => 'new'
		end
	end
	
	def import
  		@new_chapter_url = update_from_wiki_path(@chapter)
  	end
  
	def update
		if @chapter.update_attributes(params[:manual_chapter])
			flash[:notice] = "Successfully updated chapter."
			redirect_to manual_chapter_url(@chapter)
		else
			render :action => 'edit'
		end
	end

	def update_from_wiki
  		@page = WikiPage.find(params[:manual_chapter][:wiki_page_id])
  		if (@chapter != nil) && (@page != nil)  			
  			@chapter.update_from_wiki_struct(@page)
			flash[:notice] = "Successfully imported chapter."
			redirect_to manual_chapter_url(@chapter)
		else
			render :action => 'show'
		end
  	end
  
	def destroy
		@chapter.destroy
		flash[:notice] = "Successfully destroyed chapter."
		redirect_to manual_url(@chapter.manual_id)
	end

	def reorder    	
    	move_to = params[:order][:move_to]    	
    	case move_to
      		when "highest" then	@chapter.move_to_left_of(@chapter.siblings.first)
			when "lowest" then @chapter.move_to_right_of(@chapter.siblings.last)
			when "higher" then @chapter.move_left
			when "lower" then @chapter.move_right
	    end
	    @chapter.reload
    	redirect_to edit_manual_chapter_path(@chapter.parent)
  	end

	private

	def create_common_part
		@manual = Manual.find(params[:manual_id])
		@chapter = @manual.manual_chapters.build(params[:manual_chapter])
	end
	
	def fetch_wiki_pages
		@wiki_pages = WikiPage.all.sort_by(&:title)
	end

	def find_chapter
		@chapter = ManualChapter.find_by_id(params[:id])
		if !(@chapter)
			render_404
		end	
	end

	def new_common_part
		@manual = Manual.find(params[:manual_id])
		@chapter = @manual.manual_chapters.build
		@chapter.parent_chapter_id = params[:parent_id]
	end
end