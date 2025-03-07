require_relative '../queries/discipline_query'

module Commands
  class AllDisciplineGrade
    def initialize
      @query = Queries::DisciplineQuery.new
    end

    def call
      result = @query.avg_disciplines_grade
      case result[:status]
      when 'calculated'
        puts "Средняя оценка за все Дисциплины: #{result[:overall_average]}"
      when 'no grades'
        puts 'Средняя оценка отсутствует'
      end
    end
  end
end
