require "test_helper"

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @valid_attributes = {
          name: "Test User",
          email: "test@example.com",
          phone: "+1234567890"
        }
        @invalid_attributes = {
          name: "",
          email: "invalid-email",
          phone: ""
        }
      end

      # GET /api/v1/users
      test "should get index" do
        get api_v1_users_url, as: :json
        assert_response :success

        json_response = JSON.parse(response.body)
        assert json_response.is_a?(Array)
        assert json_response.length > 0
      end

      # GET /api/v1/users/1
      test "should show user" do
        get api_v1_user_url(@user), as: :json
        assert_response :success

        json_response = JSON.parse(response.body)
        assert_equal @user.id, json_response["id"]
        assert_equal @user.name, json_response["name"]
        assert_equal @user.email, json_response["email"]
      end

      test "should handle user not found" do
        assert_raises(ActiveRecord::RecordNotFound) do
          get api_v1_user_url(99999), as: :json
        end
      end

      # POST /api/v1/users
      test "should create user" do
        assert_difference("User.count") do
          post api_v1_users_url, params: { user: @valid_attributes }, as: :json
        end

        assert_response :created
        json_response = JSON.parse(response.body)
        assert_equal @valid_attributes[:name], json_response["name"]
        assert_equal @valid_attributes[:email], json_response["email"]
      end

      test "should not create user with invalid attributes" do
        assert_no_difference("User.count") do
          post api_v1_users_url, params: { user: @invalid_attributes }, as: :json
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert json_response.key?("errors")
      end

      # PATCH/PUT /api/v1/users/1
      test "should update user" do
        patch api_v1_user_url(@user), params: { user: @valid_attributes }, as: :json
        assert_response :success

        @user.reload
        assert_equal @valid_attributes[:name], @user.name
        assert_equal @valid_attributes[:email], @user.email
      end

      test "should not update user with invalid attributes" do
        patch api_v1_user_url(@user), params: { user: @invalid_attributes }, as: :json
        assert_response :unprocessable_entity

        json_response = JSON.parse(response.body)
        assert json_response.key?("errors")
      end

      # DELETE /api/v1/users/1
      test "should destroy user" do
        assert_difference("User.count", -1) do
          delete api_v1_user_url(@user), as: :json
        end

        assert_response :no_content
      end
    end
  end
end
