module Services
  class InputLabWorkGrade
    def call
      loop do
        puts "Введите оценку (0-10) или оставьте строку пустой в случае отсутствия оценки:"
        @grade = gets.chomp
        return nil if @grade.strip.empty?

        @grade = @grade.to_i
        return @grade if grade.between?(0,10)

        puts 'Оценка должна быть в пределах от 0 до 10.'
      end
    end
  end
end
