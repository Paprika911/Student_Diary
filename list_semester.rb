require_relative 'database'

class ListSemester
  def initialize
    @db = Database.new
  end

  def call
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
