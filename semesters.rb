require_relative 'list_semester'

class Semester
  attr_accessor :semester_name, :start_date, :end_date

  def initialize(semester_name:, start_date:, end_date:)
    @semester_name = semester_name
    @start_date = start_date
    @end_date = end_date
  end

  def self.list_semesters
    ListSemester.perform
  end
end
