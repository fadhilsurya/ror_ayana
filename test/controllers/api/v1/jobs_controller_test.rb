require "test_helper"

module Api
  module V1
    class JobsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @job = jobs(:one)
        @valid_attributes = {
          title: "Test Job",
          description: "Test job description",
          status: "pending",
          user_id: @user.id
        }
        @invalid_attributes = {
          title: "",
          description: "",
          status: "invalid_status",
          user_id: nil
        }
      end

      # GET /api/v1/jobs
      test "should get index" do
        get api_v1_jobs_url, as: :json
        assert_response :success
        
        json_response = JSON.parse(response.body)
        assert json_response.is_a?(Array)
      end

      test "should get jobs filtered by user_id" do
        get api_v1_jobs_url, params: { user_id: @user.id }, as: :json
        assert_response :success
        
        json_response = JSON.parse(response.body)
        json_response.each do |job|
          assert_equal @user.id, job["user_id"]
        end
      end

      # GET /api/v1/jobs/1
      test "should show job" do
        get api_v1_job_url(@job), as: :json
        assert_response :success
        
        json_response = JSON.parse(response.body)
        assert_equal @job.id, json_response["id"]
        assert_equal @job.title, json_response["title"]
      end

      # POST /api/v1/jobs
      test "should create job" do
        assert_difference('Job.count') do
          post api_v1_jobs_url, params: { job: @valid_attributes }, as: :json
        end
        
        assert_response :created
        json_response = JSON.parse(response.body)
        assert_equal @valid_attributes[:title], json_response["title"]
      end

      test "should not create job with invalid attributes" do
        assert_no_difference('Job.count') do
          post api_v1_jobs_url, params: { job: @invalid_attributes }, as: :json
        end
        
        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert json_response.key?("errors")
      end

      # PATCH/PUT /api/v1/jobs/1
      test "should update job" do
        patch api_v1_job_url(@job), params: { job: @valid_attributes }, as: :json
        assert_response :success
        
        @job.reload
        assert_equal @valid_attributes[:title], @job.title
      end

      test "should not update job with invalid attributes" do
        patch api_v1_job_url(@job), params: { job: @invalid_attributes }, as: :json
        assert_response :unprocessable_entity
        
        json_response = JSON.parse(response.body)
        assert json_response.key?("errors")
      end

      # DELETE /api/v1/jobs/1
      test "should destroy job" do
        assert_difference('Job.count', -1) do
          delete api_v1_job_url(@job), as: :json
        end
        
        assert_response :no_content
      end
    end
  end
end