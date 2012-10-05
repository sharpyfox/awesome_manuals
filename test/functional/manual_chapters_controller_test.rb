require File.dirname(__FILE__) + '/../test_helper'

class ManualChaptersControllerTest < ActionController::TestCase
	fixtures :manual_chapters
  
	def test_no_index_route
		assert_raises(ActionController::UnknownAction) do
      		get :index
    	end
	end
  
	def test_show
		get :show, :id => ManualChapter.first
		assert_template 'show'
	end
  
	def test_new
		get :new, :manual_id => Manual.first
		assert_template 'new'
	end
  
	def test_create_invalid
		ManualChapter.any_instance.stubs(:valid?).returns(false)
		post :create, :manual_id => Manual.first
		assert_template 'new'
	end
  
	def test_create_valid
		ManualChapter.any_instance.stubs(:valid?).returns(true)
		post :create, :manual_id => Manual.first
		chapter = assigns(:chapter)
		assert_equal chapter.manual, Manual.first
		assert_redirected_to manual_chapter_url(chapter)
	end
  
	def test_edit
		get :edit, :id => ManualChapter.first
		assert_template 'edit'
	end
  
	def test_update_invalid
		ManualChapter.any_instance.stubs(:valid?).returns(false)
		put :update, :id => ManualChapter.first
		assert_template 'edit'
	end
  
	def test_update_valid
		ManualChapter.any_instance.stubs(:valid?).returns(true)
		put :update, :id => ManualChapter.first
		assert_redirected_to manual_chapter_url(assigns(:chapter))
	end
  
	def test_destroy
		manual_chapter = ManualChapter.first
		delete :destroy, :id => manual_chapter
		assert_redirected_to manual_url(manual_chapter.manual)
		assert !ManualChapter.exists?(manual_chapter.id)
	end
end
