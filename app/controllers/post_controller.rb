class PostController < BaseController
	def list
		@posts = Post.paginate_by_blog_id @blog.id, :page => params[:page], :per_page => '5', :order => 'created_at DESC'
	end

	def show
		@post = @blog.find_post_by_slug(params[:slug])
		redirect_to :action => :list if @post.nil?
	end

	def tag
		@posts = Post.find_tagged_for_blog(@blog, params[:tag])
		render :action => :list
	end

	def feedburner
		@posts = Post.find_for_feed(@blog)
		headers['Content-Type'] = 'application/xml'
		render :layout => false
	end

	def homepage
		@posts = Post.find_for_feed(@blog).slice(0, 5)
		headers['Cache-Control'] = 'public, max-age=300'
		render :layout => false
	end
end
