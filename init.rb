require 'redmine'

unless Redmine::Plugin.registered_plugins.keys.include?(:redmine_awesome_pdf_export)
	Redmine::Plugin.register :redmine_awesome_pdf_export do
		name 'Awesome Redmine PDF Documentation plugin'
		author 'Nikita Vasiliev'
		author_url 'mailto:sharpyfox@gmail.com'
		description 'Redmine plugin, which help to create pdf documentation'
		version '0.0.1'
		# Redmine Version
		requires_redmine :version_or_higher => '1.3.0'

		permission :awesome_manuals, {:awesome_manuals => [:index, :new, :edit, :delete]}

		# Menu
		menu :application_menu, :awesome_manuals, { :controller => 'manuals', :action => 'index' }, :caption => :manuals		
	end
end