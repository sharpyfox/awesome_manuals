class CreateManuals < ActiveRecord::Migration
	def self.up
		create_table :manuals do |t|
			t.string :title
			t.timestamps
		end
	end
  
	def self.down
		drop_table :manuals
	end
end
