require File.dirname(__FILE__) + '/../test_helper'

class ManualsControllerTest < ActionController::TestCase
	fixtures :manuals
  
	def test_index
		get :index
		assert_template 'index'
	end
  
	def test_show
		get :show, :id => Manual.first
		assert_template 'show'
	end

	def test_show_nonexistent
		get :show, :id => Manual.last.id + 10
		
		assert_response :not_found
		assert_template 'common/error'
	end
  
	def test_new
		get :new
		assert_template 'new'
	end
  
	def test_create_invalid
		Manual.any_instance.stubs(:valid?).returns(false)
		post :create
		assert_template 'new'
	end
  
	def test_create_valid
		Manual.any_instance.stubs(:valid?).returns(true)
		post :create
		man = assigns(:manual)
		assert_equal 1, man.manual_chapters.count
		assert_redirected_to manual_url(assigns(:manual))
	end

	def test_root_chapter_recreate		
		man = manuals(:project_without_chapters)
		assert man.root != nil		
	end
  
	def test_edit
		get :edit, :id => Manual.first
		assert_template 'edit'
	end

	def test_edit_nonexistent
		get :edit, :id => Manual.last.id + 10
		
		assert_response :not_found
		assert_template 'common/error'
	end
  
	def test_update_invalid
		Manual.any_instance.stubs(:valid?).returns(false)
		put :update, :id => Manual.first
		assert_template 'edit'
	end
  
	def test_update_valid
		Manual.any_instance.stubs(:valid?).returns(true)
		put :update, :id => Manual.first
		assert_redirected_to manual_url(assigns(:manual))
	end

	def test_update_nonexistent
		put :show, :id => Manual.last.id + 10
		
		assert_response :not_found
		assert_template 'common/error'
	end
  
	def test_destroy
		manual = manuals(:with_one_child)
		assert_equal 1, ManualChapter.find_all_by_manual_id(manual.id).count
		delete :destroy, :id => manual
		assert_redirected_to manuals_url
		assert !Manual.exists?(manual.id)
		assert_equal 0, ManualChapter.find_all_by_manual_id(manual.id).count
	end

	def test_destroy_nonexistent
		delete :destroy, :id => Manual.last.id + 10
		
		assert_response :not_found
		assert_template 'common/error'
	end
end
