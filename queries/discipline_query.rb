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

    private

    def fetch_disciplines
      Databases::Postgresql.perform_query(query: 'SELECT * FROM disciplines')
    end

    def display_disciplines(disciplines)
      return puts 'Дисциплины отсутствуют.' if disciplines.ntuples.zero?

      disciplines.each { |row| puts "Дисциплина: #{row['name']}."}
    end
  end
end
