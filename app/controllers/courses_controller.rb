class CoursesController < ApplicationController

	def index
	  courses = Course.includes(:tutors)
	  	if courses.present?
			render json: serialize_course(courses), status: :ok
		else
			render json: { errors: "Record not found" }, status: :no_content
		end
	end

	def create
	  	course = Course.new(course_params)
	 	if course.save
			render json: serialize_course(course), status: :created
		else
			render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
		end
	end

	private

	def course_params
	  	params.require(:course).permit(:name, :code, tutors_attributes: [:name, :email])
	end

	def serialize_course(courses)
    	CourseSerializer.new(courses).serializable_hash
  	end
end

