module Services
  class InputLabWorkName
    def call
      input_lab_work_name
    end

  private

    def input_lab_work_name
      loop do
        puts 'Введите название Лабораторной Работы:'
        @lab_work_name = gets.chomp
        return @lab_work_name if valid_lab_work_name?
      end
    end

    def valid_lab_work_name?
      return puts 'Название Лабораторной Работы не может быть пустым.' if @lab_work_name.nil? || @lab_work_name.strip.empty?

      true
    end
  end
end
