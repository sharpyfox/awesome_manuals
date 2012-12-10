ActionController::Routing::Routes.draw do |map|
	map.resources :manuals, :has_many => :manual_chapters, :shallow => true
	map.resources :manual_chapters, :only => [:index]

	map.reorder_manual_chapters '/manual_chapters/:id/reorder', :controller => 'manual_chapters', :action => 'reorder'

	map.generate_manual '/manuals/:id/generate', :controller => 'manuals', :action => 'generate'

	map.import_from_wiki '/manual_chapters/:id/import', :controller => 'manual_chapters', :action => 'import', :conditions => {:method => :get}
	
	map.new_chapter_from_wiki '/manuals/:manual_id/manual_chapters/new_from_wiki', :controller => 'manual_chapters', :action => 'new_from_wiki', :conditions => {:method => :get}
	
	map.create_chapter_from_wiki '/manuals/:manual_id/manual_chapters/create_from_wiki', :controller => 'manual_chapters', :action => 'create_from_wiki', :conditions => {:method => :post}
	
	map.update_from_wiki '/manual_chapters/:id/update_from_wiki', :controller => 'manual_chapters', :action => 'update_from_wiki', :conditions => {:method => :put}

	map.chapt_and_pages_intersect '/manual_chapters/:id/intersect', :controller => 'manual_chapters', :action => 'intersect', :conditions => {:method => :get}
end