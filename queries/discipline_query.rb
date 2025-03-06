require_relative '../databases/postgresql'
require_relative '../discipline'

module Queries
  class DisciplineQuery
    def find_by_name(discipline_name:, semester_id:)
      result = Databases::Postgresql.perform_query(
        query: 'SELECT id, name, semester_id FROM disciplines WHERE name = $1 and semester_id = $2',
        params: [discipline_name, semester_id]
      )
      return nil if result.ntuples.zero?

      row = result[0]
      Discipline.new(
        id: row['id'],
        discipline_name: row['name'],
        semester_id: row['semester_id']
      )
    end

    def all_disciplines
      display_disciplines(fetch_disciplines)
    end

    def all_marks
      display_marks(fetch_disciplines)
    end

    private

    def fetch_disciplines
      disciplines = Databases::Postgresql.perform_query(query: 'SELECT * FROM disciplines')
      disciplines.ntuples.zero? ? (puts 'Дисциплины отсутствуют.') : disciplines
    end

    def display_disciplines(disciplines)
      disciplines.each { |row| puts "Дисциплина: #{row['name']}." } if disciplines&.ntuples&.positive?
    end

    def display_marks(disciplines)
      disciplines.each { |row| puts "Дисциплина: #{row['name']} Оценка: #{row['grade']}" } if disciplines&.ntuples&.positive?
    end
  end
end
