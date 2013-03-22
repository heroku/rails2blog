# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'd5132ade0e1f6b3abb23624f3f01a98f'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  before_filter :load_blog
  before_filter :authenticate

  layout :fetch_theme

protected

  def authenticate
    return true unless ENV["ACCESS_PASSWORD"]
    authenticate_or_request_with_http_basic do |username, password|
      password == ENV["ACCESS_PASSWORD"]
    end
  end

  def load_blog
    @blog = Blog.find_from_host(request.host)
    render :nothing, :status => 404 unless @blog
  end

  def fetch_theme
    @blog.theme || 'application'
  end
end
