class AddOwnerToBlog < ActiveRecord::Migration
	def self.up
		add_column(:blogs, :owner_id, :integer)
	end

	def self.down
		remove_column(:blogs, :owner_id)
	end
end
