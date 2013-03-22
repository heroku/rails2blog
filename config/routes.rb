ActionController::Routing::Routes.draw do |map|
	map.connect 'admin', :controller => 'admin/post'

	map.post 'archives/:year/:month/:day/:slug', :controller => 'post', :action => 'show'
	map.tag 'tags/:tag', :controller => 'post', :action => 'tag'

	map.connect 'rss_feedburner', :controller => 'post', :action => 'feedburner'
	map.connect 'homepage.js', :controller => 'post', :action => 'homepage'

	# Install the default routes as the lowest priority.
	map.connect ':controller/:action/:id'
	map.connect ':controller/:action/:id.:format'

	map.root :controller => 'post', :action => 'list'
end
