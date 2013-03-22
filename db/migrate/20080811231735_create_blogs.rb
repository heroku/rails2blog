class CreateBlogs < ActiveRecord::Migration
	def self.up
		create_table :blogs do |t|
			t.string :name, :null => false
			t.string :subdomain
			t.boolean :is_default, :default => false, :null => false
			t.timestamps
		end
	end

	def self.down
		drop_table :blogs
	end
end
