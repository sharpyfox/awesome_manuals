class CreateManualChapters < ActiveRecord::Migration
	def self.up
		create_table :manual_chapters do |t|
			t.references :manual			
			t.string :custom_title
			t.boolean :use_custom_title
			t.references :wiki_page
			
			# awesome_nested_set
			t.integer :parent_id
			t.integer :lft
			t.integer :rgt
			
			t.timestamps
		end
	end	
  
	def self.down
		drop_table :manual_chapters
	end
end
