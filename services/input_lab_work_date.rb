require 'date'

module Services
  class InputLabWorkDate
    def call
      input_lab_work_Date
    end

  private

    def input_lab_work_date
      loop do
        puts 'Введите дату окончания выполнения Лабораторной Работы:'
        @lab_work_date = gets.chomp
        return @lab_work if valid_date?
      end
    end

    def valid_date?
      return puts 'Дата должна быть заполнена.' if @lab_work_date.empty?

      begin
        Date.strptime(@lab_work_date, '%Y-%m-%d')
      rescue ArgumentError
        return puts 'Неверный формат записи даты окончания выполнения Лабораторной Работы (необходимый формат: YYYY-MM-DD)'
      end

      true
    end
  end
end
