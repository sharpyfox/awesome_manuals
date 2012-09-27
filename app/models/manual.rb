class Manual < ActiveRecord::Base
	has_many :manual_chapters, :dependent => :destroy#, :order => :chapter_order
	validates_presence_of :title

	after_save :check_root_node

	def chapters
		return manual_chapters
	end

	def check_root_node
		root # dummy
	end

	def root
		if manual_chapters.empty?
			return create_root		
		else
			return manual_chapters.first.root
		end
	end

	private

	def create_root
		chapter = manual_chapters.build		
		chapter.save

		return chapter
	end
end
