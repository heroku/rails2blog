class Post < ActiveRecord::Base
	before_save :parse_post
	after_create :set_slug

	belongs_to :blog
	belongs_to :author

	validates_presence_of :title, :author, :blog

	acts_as_taggable_on :tags

	SLUG_TOKEN = '_'

	def set_slug
		self.slug = '' if self.slug.nil?
		self.slug.strip!

		if self.slug.size == 0
			self.slug = "#{title.downcase.gsub(',', '').gsub(/[^a-z0-9]+/i, SLUG_TOKEN).gsub(/#{SLUG_TOKEN}$/,'').gsub(/^#{SLUG_TOKEN}/,'').gsub(/([#{SLUG_TOKEN}]+)/,SLUG_TOKEN)}"
			# this kind of sucks but works.
			connection.execute("UPDATE posts SET slug = #{connection.quote(self.slug)} WHERE id=#{id}")
		end
	end

	def to_s
		title
	end

	def full_content
		"#{content}#{extended_content}"
	end

  # Don't disrupt old posts, but I'd rather use the same markdown parser use by
  # gist.github.com for new posts.
  def parser_class
    if new_record? or created_at > Time.mktime(2011, 6, 17)
      Redcarpet
    else
      RedCloth
    end
  end

	def parse_post
		[ 'content', 'extended_content' ].each do |field|
			self["#{field}_raw"] ||= ''
			parser = parser_class.new(self["#{field}_raw"])
			self[field] = parser.to_html
		end

		self.content_searchable = Post.strip_html("#{self.content} #{self.extended_content}")

		true
	end

	def self.strip_html(str, allow = [], add_space = true) # replace_entities = false)
		str = str.strip || ''

		allow_arr = allow.join('|') << '|\/'
		str.gsub!(/<(\/|\s)*[^(#{allow_arr})][^>]*>/, (add_space ? ' ' : ''))

		str.gsub!('&#8211;', ' - ')   # en-dash
		str.gsub!('&#8212;', ' -- ')  # em-dash
		str.gsub!('&mdash;', ' -- ')  # em-dash
		str.gsub!('&#8216;', "'")     # open single quote
		str.gsub!('&#8217;', "'")     # close single quote
		str.gsub!('&#8220;', '"')     # open double quote
		str.gsub!('&#8221;', '"')     # close double quote
		str.gsub!('&#8230;', ' ... ') # ellipsis
		str.gsub!('&amp;',   '&')     # ampersand
		str.gsub!('&quot;',  '"')     # quote
		str.gsub!('&#039;',  "'")     # apos
		str.gsub!('&lt;',    ' < ')   # less than
		str.gsub!('&gt;',    ' > ')   # greater than
		str.gsub!(/[ ]+/,    ' ')

		str.strip!
		str
	end

	def next_post
		@next_post ||= Post.find(:first, :conditions => ['blog_id = ? AND created_at > ?', self.blog_id, self.created_at], :order => "created_at", :limit => 1)
	end

	def prev_post
		@prev_post ||= Post.find(:first, :conditions => ['blog_id = ? AND created_at < ?', self.blog_id, self.created_at], :order => "created_at DESC", :limit => 1)
	end

	def year
		created_at.year
	end

	def month
		created_at.month
	end

	def day
		created_at.day
	end

	def self.find_tagged_for_blog(blog, tag)
		with_scope(:find => { :conditions => [ "blog_id = ?", blog.id ] }) do
			find_tagged_with(tag)
		end
	end

	def self.find_all_posts_for_blog(blog)
		find(:all, :conditions => [ "blog_id = ?", blog.id ], :order => 'created_at DESC')
	end

	def self.find_for_feed(blog)
		find(:all, :conditions => [ "blog_id = ?", blog.id ], :order => 'created_at DESC', :limit => 20)
	end
end
