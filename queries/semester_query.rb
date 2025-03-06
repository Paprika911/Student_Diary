require_relative '../databases/postgresql'
require_relative '../semester'

module Queries
  class SemesterQuery
    def find_by_name(semester_name:)
      result = Databases::Postgresql.perform_query(
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
    end

    def all_semester_disciplines(semester_name:)
      semester = find_by_name(semester_name: semester_name)
      return 'Семестр с таким названием не найден.' if semester.nil?

      display_disciplines(fetch_disciplines(semester_id: semester.id))
    end

    def all_semesters_marks
      display_semesters_marks(fetch_semesters)
    end

    private

    def fetch_semesters
      semesters = Databases::Postgresql.perform_query(query: 'SELECT * FROM semesters')
      semesters.ntuples.zero? ? (puts 'Семестры отсутствуют.') : semesters
    end

    def fetch_disciplines(semester_id:)
      Databases::Postgresql.perform_query(
        query: 'SELECT name FROM disciplines WHERE semester_id = $1',
        params: [semester_id]
      )
    end

    def display_semesters(semesters)
      return unless semesters&.ntuples&.positive?

      semesters.each { |row| puts "Название: #{row['name']}, дата начала: #{row['start_date']}, дата окончания: #{row['end_date']}." }
    end

    def display_disciplines(disciplines)
      return puts 'В Семестре отсутствуют Дисциплины' if disciplines.ntuples.zero?

      disciplines.each { |row| puts "Дисциплина: #{row['name']}." }
    end

    def display_semesters_marks(semesters)
      return unless semesters&.ntuples&.positive?

      semesters.each { |row| puts "Семестр: #{row['name']} Оценка: #{row['grade']}" }
    end
  end
end
