class ManualsController < ApplicationController
	unloadable

	def index
		@manuals = Manual.find(:all)
	end
  
	def show
		@manual = Manual.find(params[:id])		
	end

	def generate
		@manual = Manual.find(params[:id])

        render :pdf => @manual.title, # pdf will download as {manual_title}.pdf
        	:layout => 'manual_pdf', # uses views/layouts/manual_pdf.erb
       	 	:show_as_html => params[:debug].present?, # renders html version if you set debug=true in URL
        	:wkhtmltopdf  => 'C:\Program Files\wkhtmltopdf\wkhtmltopdf.exe', # path to binary
        	:header => { :right => '[page]' }#,        	
        	#:extra => 'toc --xsl-style-sheet "C:\test.xsl"'
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
		@chapter = @manual.root
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
