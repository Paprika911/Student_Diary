module Services
  class InputLabWorkGrade
    def call
      loop do
        puts 'Введите оценку (0-10) или оставьте строку пустой в случае отсутствия оценки:'
        @grade = gets.chomp
        return nil if @grade.strip.empty?

        return @grade if @grade.match?(/\A[0-9]+\z/) && @grade.to_i.between?(0, 10)

        puts 'Оценка должна быть в пределах от 0 до 10.'
      end
    end
  end
end
