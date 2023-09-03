class CourseSerializer
  include JSONAPI::Serializer
  attributes :name, :code
  has_many :tutors
end
