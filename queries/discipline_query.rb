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

    def discipline_grade(discipline_id:)
      avg_lab_works_grade(discipline_id: discipline_id)
    end

    def avg_disciplines_grade
      all_disciplines_grade
    end

    private

    def fetch_disciplines
      disciplines = Databases::Postgresql.perform_query(query: 'SELECT * FROM disciplines')
      disciplines.ntuples.zero? ? (puts 'Дисциплины отсутствуют.') : disciplines
    end

    def display_disciplines(disciplines)
      disciplines.each { |row| puts "Дисциплина: #{row['name']}." } if disciplines&.ntuples&.positive?
    end

    def avg_lab_works_grade(discipline_id:)
      result = Databases::Postgresql.perform_query(
        query: '
          SELECT 
            d.id AS discipline_id,
            d.name AS discipline_name,
            AVG(lw.grade) AS average_grade
          FROM disciplines d
          LEFT JOIN lab_works lw ON lw.discipline_id = d.id
          WHERE d.id = $1
          GROUP BY d.id, d.name',
        params:[discipline_id]
      )
      return {
        status: 'no data'
      } if result.ntuples.zero?

      avg = result[0]['average_grade']&.to_f&.round(2)
      {
        discipline_id: discipline_id, 
        discipline_name: result[0]['discipline_name'] , 
        average_grade: avg, 
        status: avg.nil? ? 'no grades' : 'calculated'
      }
    end

    def all_disciplines_grade
      result = Databases::Postgresql.perform_query(
        query:'
        SELECT AVG(lw.grade) AS overall_average
        FROM disciplines d
        LEFT JOIN lab_works lw ON lw.discipline_id = d.id'
      )
      return {
        overall_average: nil,
        status: 'no grades'
      } if result.ntuples.zero? || result[0]['overall_average'].nil?

      overall_average = result[0]['overall_average']&.to_f&.round(2)
      {
        overall_average: overall_average,
        status: 'calculated'
      }
    end
  end
end
