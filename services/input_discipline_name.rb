module Services
  class InputDisciplineName
    def call
      input_discipline_name
    end

  private

    def input_discipline_name
      loop do
        puts 'Введите название Дисциплины:'
        @discipline_name = gets.chomp
        return @discipline_name if valid_discipline_name?
      end
    end

    def valid_discipline_name?
      return puts 'Название Дисциплины не может быть пустым.' if @discipline_name.nil? || @discipline_name.strip.empty?

      true
    end
  end
end
