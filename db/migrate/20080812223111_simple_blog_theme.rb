class SimpleBlogTheme < ActiveRecord::Migration
	def self.up
		add_column(:blogs, :theme, :string)
	end

	def self.down
		remove_column(:blogs, :theme)
	end
end
