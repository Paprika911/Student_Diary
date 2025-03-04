require_relative '../databases/postgresql'
require_relative '../queries/lab_work_query'
require_relative '../services/input_lab_work_name'
require_relative 'delete_obj'

module Commands
  class DeleteLabWork
    def initialize(discipline_id:)
      @discipline_id = discipline_id
    end

    def call
      input_name
      return unless lab_work_exist?

      delete_lab_work
    end

    private

    def input_name
      @lab_work_name = Services::InputLabWorkName.new.call
    end

    def lab_work_exist?
      lab_work = Queries::LabWorkQuery.new.find_by_name(
        lab_work_name: @lab_work_name,
        discipline_id: @discipline_id
      )
      return puts "Лабораторная Работа с названием #{@lab_work_name} не найдена." if lab_work.nil?

      @lab_work_id = lab_work.id
      true
    end

    def delete_lab_work
      Commands::DeleteRecord.new(table: 'lab_works', id: @lab_work_id).call
    end
  end
end
