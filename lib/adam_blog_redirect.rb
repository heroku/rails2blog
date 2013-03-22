class AdamBlogRedirect
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env['SERVER_NAME'] == 'adam.blog.heroku.com'
      url = Rack::Request.new(env).url.sub(/adam\.blog\.heroku\.com/, 'adam.heroku.com')
      [ 301, { 'Location' => url }, [ "Redirecting to #{url}" ] ]
    else
      @app.call(env)
    end
  end
end
