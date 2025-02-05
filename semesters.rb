require_relative 'database'
require 'date'

class ListSemester
  def initialize(db:)
    @db = db
  end

  def call
    semesters = fetch_semesters
    display_semesters(semesters)
  end

  private 
  
  def fetch_semesters
    @db.exec(query: 'SELECT * FROM semesters')
  end

  def display_semesters(semesters)
    return puts 'В таблице нет данных.' if semesters.ntuples.zero?

    result.each do |row|
      puts "Название: #{row['name']}, дата начала: #{row['start_date']}, дата окончания: #{row['end_date']}."
    end
  end
end

class Semester
  attr_accessor :semester_name, :start_date, :end_date

  def initialize(semester_name:, start_date:, end_date:)
    @semester_name = semester_name
    @start_date = start_date
    @end_date = end_date
  end

  def self.list_semesters(db)
    service = ListSemester.new(db: db)
    service.call
  end
end
