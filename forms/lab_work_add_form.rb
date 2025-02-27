require_relative '../lab_work'
require_relative '../databases/postgresql'
require_relative '../queries/lab_work_query'
require_relative '../services/input_lab_work_name'
require_relative '../services/input_lab_work_date'
require_relative '../services/input_lab_work_grade'

module Forms
  class LabWorkForm
    def initialize(discipline_id:)
      @discipline_id = discipline_id
    end

    def call
      input_name
      return unless lab_work_already_exist?

      input_date
      input_status
      input_grade
      save_db
    end

    private

    def input_name
      @lab_work_name = Services::InputLabWorkName.call
    end

    def lab_work_already_exist?
    result = Queries::LabWorkQuery.new.find_by_name(
      lab_work_name: @lab_work_name,
      discipline_id: @discipline_id
    )
    return puts 'Лабораторная Работа с таким названием уже существует.' unless result.nil?

    true
    end

    def input_date
      @deadline = Services::InputLabWorkDate.call  
    end

    def input_status
      @grade = Services::InputLabWorkGrade.call
    end

    def input_grade
      return @status = false if @grade.nil?

      @status = true
    end

    def save_db
      @db.Databases::Postgresql.perform_query(
        query: 'INSERT INTO lab_works (name, deadline, status, grade, discipline_id) VALUES ($1, $2, $3, $4, $5)',
        params: [@discipline_name, @deadline, @status, @grade, @discipline_id]
      )
      puts 'Лабораторная работа успешно добавлена!'
    end
  end
end
