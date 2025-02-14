require_relative '../semester'
require_relative '../database'
require_relative '../queries/semester_query'
require 'date'

module Forms
  class SemesterForm
    def initialize
      @db = Database.new
    end

    def call
      input_name
      input_date
      save_db
    ensure
      @db.close
    end

    private

    attr_accessor :semester_name, :start_date, :end_date

    def input_name
      loop do
        puts 'Введите название Семестра:'
        @semester_name = gets.chomp
        break if valid_semester_name?
      end
    end

    def input_date
      loop do
        puts 'Введите дату начала Семестра:'
        @start_date = gets.chomp
        puts 'Введите дату окончания Семестра:'
        @end_date = gets.chomp
        break if valid_dates?
      end
    end

    def valid_semester_name?
      return puts 'Название Семестра не может быть пустым' if @semester_name.nil? || @semester_name.strip.empty?

      result = Queries::SemesterQuery.new.find_by_name(semester_name: @semester_name)
      return puts 'Семестр с таким названием уже существует.' unless result.nil?

      true
    end

    def valid_dates?
      return puts 'Дата должна быть заполнена.' if @start_date.empty? || @end_date.empty?

      begin
        start_date_obj = Date.strptime(@start_date, '%Y-%m-%d')
        end_date_obj = Date.strptime(@end_date, '%Y-%m-%d')
      rescue ArgumentError
        return puts 'Неверный формат записи даты Семестра (необходимый формат: YYYY-MM-DD)'
      end

      return puts 'Дата начала Семестра не может быть позже даты окончания.' if start_date_obj > end_date_obj

      true
    end

    def save_db
      @db.exec_params(
        query: 'INSERT INTO semesters (name, start_date, end_date) VALUES ($1, $2, $3)',
        params: [@semester_name, @start_date, @end_date]
      )
      puts 'Семестр успешно добавлен!'
    end
  end
end
