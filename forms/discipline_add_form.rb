require_relative '../discipline'
require_relative '../database'
require_relative '../queries/discipline_query'

module Forms
  class DisciplineForm
    def initialize(semester_id:)
      @db = Database.new
      @semester_id = semester_id
    end

    def call
      input_name
      save_db
    ensure
      @db.close
    end

    private

    def input_name
      loop do
        puts 'Введите название Дисциплины:'
        @discipline_name = gets.chomp
        break if valid_discipline_name?
      end
    end

    def valid_discipline_name?
      return puts 'Название Дисциплины не может быть пустым.' if @discipline_name.nil? || @discipline_name.strip.empty?

      result = Queries::DisciplineQuery.new.find_by_name(
        discipline_name: @discipline_name,
        semester_id: @semester_id
      )
      return puts 'Дисциплина с таким названием уже существует.' unless result.nil?

      true
    end

    def save_db
      @db.exec_params(
        query: 'INSERT INTO disciplines (name, semester_id) VALUES ($1, $2)',
        params: [@discipline_name, @semester_id]
      )
      puts 'Дисциплина успешно добавлена!'
    end
  end
end
