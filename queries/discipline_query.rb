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
      process_result(perform_discipline_query(discipline_id), discipline_id)
    end

    def all_disciplines_grade
      result = Databases::Postgresql.perform_query(
        query: <<-SQL
          SELECT AVG(lw.grade) AS overall_average
          FROM disciplines d
          LEFT JOIN lab_works lw ON lw.discipline_id = d.id
        SQL
      )
      return { status: :no_data } if result.ntuples.zero?

      overall_average = result[0]['overall_average']&.to_f&.round(2)
      status = overall_average.present? ? :calculated : :no_grades

      { overal_average: overall_average, status: status }
    end

    private

    def fetch_disciplines
      disciplines = Databases::Postgresql.perform_query(query: 'SELECT * FROM disciplines')
      disciplines.ntuples.zero? ? (puts 'Дисциплины отсутствуют.') : disciplines
    end

    def display_disciplines(disciplines)
      disciplines.each { |row| puts "Дисциплина: #{row['name']}." } if disciplines&.ntuples&.positive?
    end

    def perform_discipline_query(discipline_id)
      Databases::Postgresql.perform_query(
        query: <<-SQL,
          SELECT d.id AS discipline_id,
                 d.name AS discipline_name,
                 AVG(lw.grade) AS average_grade
          FROM disciplines d
          LEFT JOIN lab_works lw ON lw.discipline_id = d.id
          WHERE d.id = $1
          GROUP BY d.id, d.name,
        SQL
        params: [discipline_id]
      )
    end

    def process_result(result, discipline_id)
      return { status: :no_data } if result.ntuples.zero?

      average_grade = result[0]['average_grade']&.to_f&.round(2)
      status = average_grade.present? ? :calculated : :no_grades

      {
        discipline_id: discipline_id,
        discipline_name: result[0]['discipline_name'],
        average_grade: average_grade,
        status: status
      }
    end
  end
end
