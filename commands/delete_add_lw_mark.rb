require_relative '../databases/postgresql'
require_relative '../services/input_lab_work_grade'

module Commands
  class AddDeleteLWMark
    def initialize(id:)
      @id = id
    end

    def call
      input_grade
      save_db
    end

    private

    def input_grade
      @grade = Services::InputLabWorkGrade.new.call
    end

    def save_db
      result = Databases::Postgresql.perform_query(
        query: 'UPDATE lab_works SET grade = $2 WHERE id = $1',
        params: [@id, @grade]
      )
      return puts 'Оценка и статус Лабораторной Работы успешно обновлены' if result.ntuples.positive?

      puts "Ошибка: Лабораторная работа с id #{@id} не найдена."
    end
  end
end
