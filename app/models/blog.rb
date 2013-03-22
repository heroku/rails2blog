class Blog < ActiveRecord::Base
	has_many :authors
	has_many :posts, :order => 'created_at DESC'

	belongs_to :owner, :class_name => 'Author'

	validates_presence_of :owner, :name

	validates_uniqueness_of :subdomain
	validates_length_of :subdomain, :minimum => 3
	validates_format_of :subdomain, :with => /^(\*\.)?([a-z0-9-]+\.)+[a-z0-9-]+$/

	validates_uniqueness_of :is_default, :if => Proc.new { |blog| blog.is_default? }, :message => "can only be set for one blog"

	acts_as_tagger

	def self.find_from_host(host)
		blog = find(:first, :conditions => [ "subdomain = ?", host ])
		return blog unless blog.nil?
		find(:first, :conditions => { :is_default => true })
	end

	def self.create_default(name, host)
		create!(:name => "default", :subdomain => host, :is_default => true)
	end

	def find_post_by_slug(slug)
		posts.find_by_slug(slug)
	rescue ActiveRecord::RecordNotFound
		nil
	end

	def post_cloud_tags
		Post.tag_counts_on(:tags, :conditions => [ "blog_id = ?", id ])
	end
end
