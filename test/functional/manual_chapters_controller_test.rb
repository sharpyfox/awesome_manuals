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
		assert assigns(:manual)
		assert assigns(:chapter)
		assert_equal Manual.first, assigns(:chapter).manual
		assert_equal nil, assigns(:chapter).parent
		assert_template 'new'
	end

	def test_new_with_parent
		get :new, :manual_id => Manual.first, :parent_id => ManualChapter.first.id
		assert assigns(:manual)
		assert assigns(:chapter)
		assert_equal Manual.first, assigns(:chapter).manual
		assert_equal ManualChapter.first.id, assigns(:chapter).parent_chapter_id
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
		manual_chapter = manual_chapters(:chapter_with_one_child)
		assert_equal 1, ManualChapter.find_all_by_parent_id(manual_chapter.id).count
		delete :destroy, :id => manual_chapter
		assert_redirected_to manual_url(manual_chapter.manual)
		assert_equal 0, ManualChapter.find_all_by_parent_id(manual_chapter.id).count
		assert !ManualChapter.exists?(manual_chapter.id)
	end
end