require 'redmine'

WINDOWS_DEFAULT_PATH = 'C:\Program Files\wkhtmltopdf\wkhtmltopdf.exe'
NIX_DEFAUL_PATH = '/usr/local/bin/wkhtmltopdf'

if RUBY_PLATFORM =~ /(win|w)32$/
	WKHTMLTOPDF_PATH = WINDOWS_DEFAULT_PATH
else
	WKHTMLTOPDF_PATH = NIX_DEFAUL_PATH
end

WKHTMLTOPDF_PATH = 

unless Redmine::Plugin.registered_plugins.keys.include?(:awesome_manuals)
	Redmine::Plugin.register :awesome_manuals do
		name 'Awesome Redmine PDF Documentation plugin'
		author 'Nikita Vasiliev'
		author_url 'mailto:sharpyfox@gmail.com'
		description 'Redmine plugin, which help to create pdf documentation'
		version '0.0.1'
		# Redmine Version
		requires_redmine :version_or_higher => '1.3.0'

		# Settings
		settings :default => {:wkhtmltopdf_bin => WKHTMLTOPDF_PATH}, 
			:partial => "awesome_manuals/settings"

		project_module :awesome_manuals_module do
			permission :edit_manuals, { 
      			:manuals => [:edit, :destroy],
      			:manual_chapters => [:edit, :destroy]
    		}
    	
    		permission :generate_manuals, { 
      			:manuals => [:generate]
    		}
    	end

		# Menu
		menu :top_menu, :awesome_manuals, { :controller => 'manuals', :action => 'index' }, :caption => :manuals
	end
end