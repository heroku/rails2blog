class ArchivesController < BaseController
	def index
		@posts = Post.find_all_posts_for_blog(@blog)
	end
end
