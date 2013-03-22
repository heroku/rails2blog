require 'digest/sha1'

class Author < ActiveRecord::Base
	has_many :blogs, :order => 'created_at'

	validates_presence_of :name, :email
	validates_length_of :name, :minimum => 3
	validates_uniqueness_of :email
	validates_length_of :email, :minimum => 3

	def reset_password(password)
		self.password = Digest::SHA1.hexdigest("#{BLOG_CONFIG['secret']}_#{password}")
		save!
	end

	def authenticate(password)
		self.password == Digest::SHA1.hexdigest("#{BLOG_CONFIG['secret']}_#{password}")
	end

	def to_s
		"#{name} (#{email})"
	end

	def self.find_heroku_user(email)
		author = Author.find(:first, :conditions => [ "email = ?", email ])
		return author unless author.nil?
		name = email.slice(0, email.index('@')).capitalize
		Author.create!(:email => email, :name => name)
	end
end
