class CreatePosts < ActiveRecord::Migration
	def self.up
		create_table :posts do |t|
			t.integer :blog_id, :null => false
			t.integer :author_id, :null => false
			t.string :title, :null => false
			t.string :slug
			t.text :content
			t.timestamps
		end
	end

	def self.down
		drop_table :posts
	end
end
