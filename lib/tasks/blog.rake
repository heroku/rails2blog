namespace :blog do
	desc "Create default blog site fetching values from ENV['BLOG_DOMAIN'], ENV['BLOG_NAME'], ENV['BLOG_AUTHOR_NAME'], and ENV['BLOG_AUTHOR_EMAIL']"
	task(:init => :environment) do
		Rake::Task['blog:create'].invoke
		Rake::Task['blog:setdefault'].invoke
	end

	desc "Create new blog site fetching values from ENV['BLOG_DOMAIN'], ENV['BLOG_NAME'], ENV['BLOG_AUTHOR_NAME'], and ENV['BLOG_AUTHOR_EMAIL']"
	task(:create => :environment) do
		author = Author.find(:first, :conditions => [ "email = ?", ENV['BLOG_AUTHOR_EMAIL'] ])
		if author.nil?
			Rake::Task['blog:author:create'].invoke
			author = Author.find_by_email(ENV['BLOG_AUTHOR_EMAIL'])
		else
			puts "Author #{author} already exists..."
		end

		puts "Creating Blog..."
		Blog.create!(:name => ENV['BLOG_NAME'], :subdomain => ENV['BLOG_DOMAIN'], :owner => author, :is_default => false)
	end

	desc "Set blog in ENV['BLOG_DOMAIN'] to default"
	task(:setdefault => :environment) do
		blog = Blog.find_by_subdomain(ENV['BLOG_DOMAIN'])
		blog.is_default = true
		blog.save!

		puts "#{blog.name} set to default blog"
	end


	namespace :author do
		desc "Creates a new author from ENV['BLOG_AUTHOR_NAME'] and ENV['BLOG_AUTHOR_EMAIL']"
		task(:create => :environment) do
			puts "Creating Author..."
			Author.create!(:name => ENV['BLOG_AUTHOR_NAME'], :email => ENV['BLOG_AUTHOR_EMAIL'])
		end

		desc "Reset an author's password, specify author by setting ENV['BLOG_AUTHOR_EMAIL']"
		task(:reset => :environment) do
			author = Author.find_by_email(ENV['BLOG_AUTHOR_EMAIL'])

			print "Enter the new password for #{author.name}: "
			password = STDIN.gets.strip
			author.reset_password(password)
			puts "Password is reset!"
		end
	end
end
