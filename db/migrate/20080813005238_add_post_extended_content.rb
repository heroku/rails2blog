class AddPostExtendedContent < ActiveRecord::Migration
	def self.up
		add_column :posts, :extended_content_raw, :text
		add_column :posts, :extended_content, :text
	end

	def self.down
		remove_column :posts, :extended_content_raw
		remove_column :posts, :extended_content
	end
end
