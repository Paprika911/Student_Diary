require_relative '../database'
require_relative '../discipline'
require_relative '../queries/base_query'

module Queries
  class DisciplineQuery < BaseQuery
    def find_by_name(discipline_name:, semester_id:)
      result = @db.exec_params(
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
    ensure
      @db.close
    end

    def all_disciplines
      display_disciplines(fetch_disciplines)
    ensure
      @db.close
    end

    private

    def fetch_disciplines
      @db.exec_params(query: 'SELECT * FROM disciplines')
    end

    def display_disciplines(disciplines)
      return puts 'Дисциплины отсутствуют.' if disciplines.ntuples.zero?

      disciplines.each { |row| puts "Дисциплина: #{row['name']}."}
    end
  end
end
