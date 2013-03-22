class AddIndices < ActiveRecord::Migration
	def self.up
		add_index :posts, :blog_id
		add_index :posts, [:blog_id, :slug]
	end

	def self.down
		remove_index :posts, :column => :blog_id
		remove_index :posts, :column => [:blog_id, :slug]
	end
end
