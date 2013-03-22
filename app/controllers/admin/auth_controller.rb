class Admin::AuthController < ApplicationController
	skip_before_filter :fetch_authorized_user

	def index
	end

	def login
		if params[:password] != (ENV["ADMIN_PASSWORD"] || "foo")
			redirect_to :action => :index, :username => params[:username]
		else
			@authorized_user = Author.find_heroku_user("#{params[:username].downcase}@heroku.com")
			session[:author_id] = @authorized_user.id
			redirect_to '/admin'
		end
	end
end
