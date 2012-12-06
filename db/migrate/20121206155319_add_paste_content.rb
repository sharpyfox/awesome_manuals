class AddPasteContent < ActiveRecord::Migration
	def self.up
		change_table :manual_chapters do |t|
      		t.boolean :paste_content, :default => true
    	end
	end

  	def self.down
		remove_column :manual_chapters, :paste_content
  	end
end
