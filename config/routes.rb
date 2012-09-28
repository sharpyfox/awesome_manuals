ActionController::Routing::Routes.draw do |map|
	map.resources :manuals, :has_many => :manual_chapters, :shallow => true
	map.resources :manual_chapters, :only => [:index]

	map.reorder_manual_chapters '/manual_chapters/:id/reorder', :controller => 'manual_chapters', :action => 'reorder'

	map.reorder_manual_chapters '/manuals/:id/generate', :controller => 'manuals', :action => 'generate'
end