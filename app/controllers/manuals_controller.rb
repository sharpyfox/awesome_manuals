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
        	:wkhtmltopdf  => Setting.plugin_redmine_awesome_pdf_export["wkhtmltopdf_bin"], # path to binary
        	:header => { :right => '[page]' },        	
        	:toc    => {
                           :depth              => 10,
                           :header_text        => "Table of content",
                           :l1_font_size       => 14,
                           :l2_font_size       => 13,
                           :l3_font_size       => 12,
                           :l4_font_size       => 12,
                           :l5_font_size       => 12,
                           :l6_font_size       => 12,
                           :l7_font_size       => 12                           
                           },
            :disable_internal_links         => true,
            :disable_external_links         => true
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
