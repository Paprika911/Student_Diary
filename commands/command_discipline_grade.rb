require_relative '../queries/discipline_query'

module Commands
  class DisciplineGrade
    def initialize
      @query = Queries::DisciplineQuery.new
    end

    def call(discipline_id:)
      result = @query.discipline_grade(discipline_id: discipline_id)
      case result[:status]
      when 'calculated'
        puts "Дисциплина: #{result[:discipline_name]}, Средняя оценка: #{result[:average_grade]}"
      when 'no grades'
        puts "Дисциплина: #{result[:discipline_name]}, Оценки отсутствуют"
      when 'no data'
        puts 'Дисциплина не найдена'
      end
    end
  end
end
