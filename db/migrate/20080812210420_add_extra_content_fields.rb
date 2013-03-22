class AddExtraContentFields < ActiveRecord::Migration
	def self.up
		add_column(:posts, :content_raw, :text)
		add_column(:posts, :content_searchable, :text)
	end

	def self.down
		remove_column(:posts, :content_raw)
		remove_column(:posts, :content_searchable)
	end
end
