class Semester
  attr_accessor :id, :semester_name, :start_date, :end_date

  def initialize(id:, semester_name:, start_date:, end_date:)
    @id = id
    @semester_name = semester_name
    @start_date = start_date
    @end_date = end_date
  end
end
