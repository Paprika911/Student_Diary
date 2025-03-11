require_relative '../queries/discipline_query'

module Commands
  class DisciplineGradeCommand
    def call(discipline_id: nil)
      if discipline_id
        result = Queries::DisciplineQuery.new.discipline_grade(discipline_id: discipline_id)
        discipline_result(result)
      else
        result = Queries::DisciplineQuery.new.all_disciplines_grade
        all_discipline_result(result)
      end
    end

    private

    def discipline_result(result)
      case result[:status]
      when :calculated
        puts "Дисциплина: #{result[:discipline_name]}, Средняя оценка: #{result[:average_grade]}"
      when :no_grades
        puts "Дисциплина: #{result[:discipline_name]}, Оценки отсутствуют"
      when :no_data
        puts 'Дисциплина не найдена'
      end
    end

    def all_discipline_result(result)
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
