require_relative '../database'
require_relative '../semester'
require_relative '../queries/base_query'

module Queries
  class SemesterQuery < BaseQuery
    def find_by_name(semester_name:)
      result = @db.exec_params(
        query: 'SELECT id FROM semesters WHERE name = $1',
        params: [semester_name]
      )
      return nil if result.ntuples.zero?

      row = result[0]
      Semester.new(
        id: row['id'],
        semester_name: row['name'],
        start_date: row['start_date'],
        end_date: row['end_date']
      )
    end

    def all_semesters
      display_semesters(fetch_semesters)
    ensure
      @db.close
    end

    def all_semester_disciplines(semester_name:)
      semester = find_by_name(semester_name: semester_name)
      return 'Семестр с таким названием не найден.' if semester.nil?

      display_disciplines(fetch_disciplines(semester_id: semester.id))
    ensure
      @db.close
    end

    private

    def fetch_semesters
      @db.exec_params(query: 'SELECT * FROM semesters')
    end

    def fetch_disciplines(semester_id:)
      @db.exec_params(
        query: 'SELECT name FROM disciplines WHERE semester_id = $1',
        params: [semester_id]
      )
    end

    def display_semesters(semesters)
      return puts 'В таблице нет данных.' if semesters.ntuples.zero?

      semesters.each do |row|
        puts "Название: #{row['name']}, дата начала: #{row['start_date']}, дата окончания: #{row['end_date']}."
      end
    end

    def display_disciplines(disciplines)
      return puts 'В Семестре отсутствуют Дисциплины' if disciplines.ntuples.zero?

      disciplines.each { |row| puts "Дисциплина: #{row['name']}."}
    end
  end
end
