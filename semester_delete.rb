require_relative 'database'

class DeleteSemester
  def initialize(semester_name:, db:)
    @semester_name = semester_name
    @db = db
  end
  
  def delete
    return false unless semester_exists?

    if delete_semester
      puts "Семестр #{@semester_name} успешно удален."
      return true
    end

    puts "Не удалось удалить Семестр с именем #{@semester_name}."
    false
  end

  def semester_exists?
    check_result = @db.exec_params(
      query: 'SELECT 1 FROM semesters WHERE name = $1',
      params: [@semester_name]
    )

    if check_result.ntuples.zero?
      puts "Семестр с именем #{@semester_name} не найден."
      return false
    end

    true
  end

  def delete_semester
    result = @db.exec_params(
      query: 'DELETE FROM semesters WHERE name = $1 RETURNING name',
      params: [@semester_name]
    )

    result.ntuples.positive?
  end
end
