require 'pg'
require 'dotenv'

Dotenv.load(File.expand_path('./.env', __dir__))

class Database
  def initialize
    @con = PG.connect(
      dbname: ENV.fetch('DB_NAME'),
      user: ENV.fetch('DB_USER'),
      password: ENV.fetch('DB_PASSWORD')
    )
  end

  def exec_params(query:, params: [])
    @con.exec_params(query, params)
  end

  def close
    @con.close
  end
end
