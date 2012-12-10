class ManualsController < ApplicationController
	unloadable

	before_filter :find_manual, :only => [:show, :edit, :generate, :update, :destroy]

	def index
		@manuals = Manual.find(:all)
	end
  
	def generate
        render :pdf => @manual.title, # pdf will download as {manual_title}.pdf
        	:layout => 'manual_pdf', # uses views/layouts/manual_pdf.erb
       	 	:show_as_html => params[:debug].present?, # renders html version if you set debug=true in URL
        	:wkhtmltopdf  => Setting.plugin_awesome_manuals["wkhtmltopdf_bin"], # path to binary
        	:header => { :right => '[page]' },        	
        	:extra => " --header-right \"[page]\" toc --xsl-style-sheet \"#{Rails.root}/public/#{Engines.plugins[:awesome_manuals].public_asset_directory}/templates/toc_template.xsl\""
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
		@chapter = @manual.root
	end
  
	def update
		@chapter = @manual.root
		if @manual.update_attributes(params[:manual])
			flash[:notice] = "Successfully updated article."
			redirect_to @manual
		else
			render :action => 'edit'
		end
	end
 
	def destroy
		@manual.destroy
		flash[:notice] = "Successfully destroyed manual."
		redirect_to manuals_url
	end

	private
		def find_manual
		@manual = Manual.find_by_id(params[:id])
		if !(@manual)
			render_404
		end	
	end
end
