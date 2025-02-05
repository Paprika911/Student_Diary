require 'pg'
require 'dotenv/load'

class Database
  def initialize
    @con = PG.connect(
      dbname: ENV.fetch('DB_NAME', nil),
      user: ENV.fetch('DB_USER', nil),
      password: ENV.fetch('DB_PASSWORD')
    )
  end

  def exec(query:)
    @con.exec(query)
  end

  def exec_params(query:, params: [])
    @con.exec_params(query, params)
  end

  def close
    @con.close
  end
end
