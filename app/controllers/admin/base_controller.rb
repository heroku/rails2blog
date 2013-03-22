class Admin::BaseController < ApplicationController
	layout 'admin'

	before_filter :fetch_authorized_user

	def index
		redirect_to :action => :list
	end

	def create
		redirect_to :action => :update
	end

	def edit
		redirect_to :action => :update, :id => params[:id]
	end

protected

	def fetch_authorized_user
		if session[:author_id]
			@authorized_user = Author.find(session[:author_id])
		else
			redirect_to '/admin/auth'
		end
	end
end
