require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest

	def setup
		@category = Category.create(name: "sports")
	end

	test "should get categories index" do
		get categories_path
		assert :success
	end

	test "show get categories new" do
		get new_category_path
		assert :success
	end

	test "show get categories show" do
		get category_path(@category)
		assert :success
	end 

end