require_relative '../queries/discipline_query'

module Commands
  class DisciplineGradeCommand
    def call_for_discipline(discipline_id:)
      result = Queries::DisciplineQuery.new.discipline_grade(discipline_id: discipline_id)
      case result[:status]
      when :calculated
        puts "Дисциплина: #{result[:discipline_name]}, Средняя оценка: #{result[:average_grade]}"
      when :no_grades
        puts "Дисциплина: #{result[:discipline_name]}, Оценки отсутствуют"
      when :no_data
        puts 'Дисциплина не найдена'
      end
    end

    def call_for_all_discipline
      result = Queries::DisciplineQuery.new.avg_disciplines_grade
      case result[:status]
      when :calculated
        puts "Средняя оценка за все Дисциплины: #{result[:overall_average]}"
      when :no_grades
        puts 'Средняя оценка отсутствует'
      when :no_data
        puts 'Дисциплины отсутствуют'
      end
    end
  end
end
