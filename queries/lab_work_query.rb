require_relative '../databases/postgresql'
require '../lab_work'

module Queries
  class LabWorkQuery
    def find_by_name(lab_work_name:, discipline_id:)
      result = Databases::Postgresql.perform_query(
        query: 'SELECT id, name, discipline_id FROM lab_works WHERE name = $1 and discipline_id = $2',
        params: [lab_work_name, discipline_id]
      )
      return nil if result.ntuples.zero?

      row = result[0]
      LabWork.new(
        id: row['id'],
        lab_work_name: row['name'],
        discipline_id: row['semester_id']
      )
    end

    def all_lab_works
      display_lab_works(fetch_lab_works)
    end

    private

    def fetch_lab_works
      @db.Databases::Postgresql.perform_query(query: 'SELECT * FROM lab_works')
    end

    def display_lab_works(lab_works)
      return puts 'Лабораторные Работы отсутствуют.' if lab_works.ntuples.zero?

      lab_works.each { |row| puts "Лабораторная Работа: #{row['name']}." }
    end
  end
end
