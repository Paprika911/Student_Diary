require_relative '../semesters'
require_relative '../database'
require_relative '../list_semester'
require 'date'

module Form
  class SemesterForm
    def initialize
      @db = Database.new
    end

    def call
      input_name
      input_date

      semester = Semester.new(
        semester_name: @semester_name,
        start_date: @start_date,
        end_date: @end_date
      )
      save_db(semester)
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

      result = FindSemesterByName.new(db: @db, semester_name: @semester_name).call

      return puts 'Семестр с таким названием уже существует.' if result.nil?

      true
    end

    def valid_dates?
      str = 'Дата должна быть заполнена.' if @start_date.empty? && @end_date.empty?
      if !(@start_date.match?(/\A\d{4}-\d{2}-\d{2}\z/) && @end_date.match?(/\A\d{4}-\d{2}-\d{2}\z/)) ||
         !(
          begin
            Date.parse(@start_date)
            Date.parse(@end_date)
            true
          rescue ArgumentError
            false
          end
        )
        str = 'Неверный формат записи даты Семестра (необходимый формат: YYYY-MM-DD)'
      end

      str = 'Дата начала Семестра не может быть позже даты окончания.' if @start_date > @end_date
      return puts str if str

      true
    end

    def save_db(semester)
      @db.exec_params(
        query: 'INSERT INTO semesters (name, start_date, end_date) VALUES ($1, $2, $3)',
        params: [semester.semester_name, semester.start_date, semester.end_date]
      )
      puts 'Семестр успешно добавлен!'
    end
  end
end
