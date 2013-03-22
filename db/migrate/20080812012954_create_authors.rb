class CreateAuthors < ActiveRecord::Migration
	def self.up
		create_table :authors do |t|
			t.string :name, :null => false
			t.string :email, :null => false
			t.string :password
			t.timestamps
		end
	end

	def self.down
		drop_table :authors
	end
end
