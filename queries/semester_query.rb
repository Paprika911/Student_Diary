require_relative '../database'

module Queries
  class SemesterQuery < BaseQuery
    def find_by_name(semester_name:)
      result = @db.exec_params(
        query: 'SELECT id FROM semesters WHERE name = $1',
        params: [semester_name]
      )
      result.ntuples.positive? ? result[0]['id'] : nil
    ensure
      @db.close
    end

    def all_semesters
      semesters = fetch_semesters
      display_semesters(semesters)
    ensure
      @db.close
    end

    private

    def fetch_semesters
      @db.exec_params(query: 'SELECT * FROM semesters')
    end

    def display_semesters(semesters)
      return puts 'В таблице нет данных.' if semesters.ntuples.zero?

      semesters.each do |row|
        puts "Название: #{row['name']}, дата начала: #{row['start_date']}, дата окончания: #{row['end_date']}."
      end
    end
  end
end
