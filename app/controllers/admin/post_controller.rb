class Admin::PostController < Admin::BaseController
	def list
		@posts = Post.paginate_by_blog_id @blog.id, :page => params[:page], :order => 'created_at DESC'
	end

	def update
		if params[:id]
			@post = Post.find(params[:id])
		else
			@post = Post.new
			@post.blog = @blog
			@post.author = @authorized_user
		end
		
		if request.post?
			@post.attributes = params[:post]
			if @post.save
				@blog.tag(@post, :with => params[:tags], :on => :tags)
				flash[:notice] = "#{@post} saved"
				redirect_to :action => :list
			end
		end
	end

	def destroy
		post = Post.find(params[:id])
		unless post.nil?
			post.destroy
			flash[:notice] = "Post #{post} removed"
		end
		redirect_to :action => :list
	end
end
