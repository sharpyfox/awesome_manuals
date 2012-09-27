class ManualChaptersController < ApplicationController
	
	before_filter :fetch_wiki_pages
	
	def index
		@manual = Manual.find(params[:manual_id])
		@chapters = @manual.manual_chapters
	end
  
	def new
		@manual = Manual.find(params[:manual_id])
		@chapter = @manual.manual_chapters.build
		@chapter.parent_chapter_id = params[:parent_id]
	end
  
	def create
		@manual = Manual.find(params[:manual_id])
		@chapter = @manual.manual_chapters.build(params[:manual_chapter])		
		if @chapter.save			
			flash[:notice] = "Successfully created chapter."
			redirect_to manual_chapter_url(@chapter)
		else
			render :action => 'new'
		end
	end
	
	def show
		@chapter = ManualChapter.find(params[:id])		
	end
  
	def edit		
		@chapter = ManualChapter.find(params[:id])		
	end
  
	def update
		@chapter = ManualChapter.find(params[:id])
		if @chapter.update_attributes(params[:manual_chapter])
			flash[:notice] = "Successfully updated chapter."
			redirect_to manual_chapter_url(@chapter)
		else
			render :action => 'edit'
		end
	end
  
	def destroy
		@chapter = ManualChapter.find(params[:id])
		@chapter.destroy
		flash[:notice] = "Successfully destroyed chapter."
		redirect_to manual_url(@chapter.manual_id)
	end

	def reorder    	
    	@chapter = ManualChapter.find(params[:id])
    	move_to = params[:order][:move_to]    	
    	case move_to
      		when "highest" then @chapter.move_left
			when "lowest" then @chapter.move_right
			when "higher" then @chapter.move_left
			when "lower" then @chapter.move_right
	    end
	    @chapter.reload
    	redirect_to edit_manual_chapter_path(@chapter.parent)
  	end
  	
	private
	
	def fetch_wiki_pages
		@wiki_pages = WikiPage.all
	end
end
