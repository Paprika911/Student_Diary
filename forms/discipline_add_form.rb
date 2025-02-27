require_relative '../discipline'
require_relative '../databases/postgresql'
require_relative '../queries/discipline_query'
require_relative '../services/input_discipline_name'

module Forms
  class DisciplineForm
    def initialize(semester_id:)
      @semester_id = semester_id
    end

    def call
      input_name
      return unless discipline_already_exist?

      save_db
    end

    private

    def input_name
      @discipline_name = Services::InputDisciplineName.call
    end

    def discipline_already_exist?
      result = Queries::DisciplineQuery.new.find_by_name(
        discipline_name: @discipline_name,
        semester_id: @semester_id
      )
      return puts 'Дисциплина с таким названием уже существует.' unless result.nil?

      true
    end

    def save_db
      @db.Databases::Postgresql.perform_query(
        query: 'INSERT INTO disciplines (name, semester_id) VALUES ($1, $2)',
        params: [@discipline_name, @semester_id]
      )
      puts 'Дисциплина успешно добавлена!'
    end
  end
end
