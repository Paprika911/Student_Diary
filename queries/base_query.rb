require_relative '../database'

class BaseQuery
  def initialize
    @db = Database.new
  end
end
