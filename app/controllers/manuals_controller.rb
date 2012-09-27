class ManualsController < ApplicationController
	def index
		@manuals = Manual.find(:all)
	end
  
	def show
		@manual = Manual.find(params[:id])		
	end
  
	def new
		@manual = Manual.new
	end
  
	def create
		@manual = Manual.new(params[:manual])
		if @manual.save
			flash[:notice] = "Successfully created manual."
			redirect_to @manual
		else
			render :action => 'new'
		end
	end
  
	def edit
		@manual = Manual.find(params[:id])
		@chapter = @manual.root
	end
  
	def update
		@manual = Manual.find(params[:id])
		if @manual.update_attributes(params[:manual])
			flash[:notice] = "Successfully updated article."
			redirect_to @manual
		else
			render :action => 'edit'
		end
	end
  
	def destroy
		@manual = Manual.find(params[:id])
		@manual.destroy
		flash[:notice] = "Successfully destroyed manual."
		redirect_to manuals_url
	end
end
