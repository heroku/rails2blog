class BaseController < ApplicationController
	before_filter :fetch_authorized_user

protected
	def fetch_authorized_user
		@authorized_user = nil
		if session[:author_id]
			@authorized_user = Author.find(session[:author_id])
		end
	end
end
