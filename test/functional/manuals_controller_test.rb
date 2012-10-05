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
		assert_redirected_to manual_url(assigns(:manual))
	end
  
	def test_edit
		get :edit, :id => Manual.first
		assert_template 'edit'
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
  
	def test_destroy
		manual = Manual.first
		delete :destroy, :id => manual
		assert_redirected_to manuals_url
		assert !Manual.exists?(manual.id)
	end
end
