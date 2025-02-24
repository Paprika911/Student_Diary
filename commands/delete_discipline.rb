require_relative '../databases/postgresql'
require_relative '../queries/discipline_query'
require_relative '../services/input_discipline_name'

module Commands
  class DeleteDiscipline
    def initialize(semester_id:)
      @semester_id = semester_id
    end

    def call
      input_name
      return unless discipline_exist?

      delete_discipline
    end

    private

    def input_name
      @discipline_name = Services::InputDisciplineName.call
    end

    def discipline_exist?
      discipline = Queries::DisciplineQuery.new.find_by_name(
        discipline_name: @discipline_name,
        semester_id: @semester_id
      )
      return puts "Дисциплина с именем #{@discipline_name} не найдена." if discipline.nil?

      @discipline_id = discipline.id
      true
    end

    def delete_discipline
      @result = Databases::Postgresql.perform_query(
        query: 'DELETE FROM disciplines WHERE id = $1 AND semester_id = $2 RETURNING name',
        params: [@discipline_id, @semester_id]
      )
      puts 'Дисциплина была успешно удалена.' if @result.ntuples.positive?
    end
  end
end
