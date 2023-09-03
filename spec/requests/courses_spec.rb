require 'rails_helper'

RSpec.describe "Courses", type: :request do

  describe "GET /index" do

    it "get listing with all courses" do
      Course.create(name: "MBA", code: "001", 
      tutors_attributes: [{name: "abc", email: "abc@gmail.com"},
        {name: "xyz", email: "xyz@gmail.com"}])

      get '/courses'

      result = JSON(response.body)
      expect(result.length).to eq(1)

      expect(response).to have_http_status(:ok)
    end

    it "courses listing record not found" do 
      get '/courses'
      
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "Post /create" do 

    it "create courses with tutors" do

      expect {
        post '/courses', params: { course: { name: "MBA", code: "001", 
        tutors_attributes: [{name: "abc", email: "abc@gmail.com"},
        {name: "xyz", email: "xyz@gmail.com"}] } }
      }.to change(Course, :count).by(1)
      .and change(Tutor, :count).by(2)
      expect(response).to have_http_status(:created)
      
    end

    it "create course witout tutors" do
      expect {
        post '/courses', params: { course: { name: "MCA", code: "002" } }
      }.to change(Course, :count).by(1)
      .and change(Tutor, :count).by(0)
      expect(response).to have_http_status(:created)

    end

    it "failed to create course with same code" do
      Course.create(name: "MBA", code: "001", 
        tutors_attributes: [{name: "abc", email: "abc@gmail.com"},
          {name: "xyz", email: "xyz@gmail.com"}])

      expect {
        post '/courses', params: { course: { name: "MBA", code: "001" } }
      }.to change(Course, :count).by(0)
      .and change(Tutor, :count).by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      
    end

  end
end
