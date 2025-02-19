require 'pg'
require 'dotenv'

Dotenv.load(File.expand_path('./.env', __dir__))

module Databases
  class Postgresql
    def self.perform_query(query:, params: [])
      con = PG.connect(
        dbname: ENV.fetch('DB_NAME'),
        user: ENV.fetch('DB_USER'),
        password: ENV.fetch('DB_PASSWORD')
      )
      result = con.exec_params(query, params)
      result
    ensure
      con.close if con
    end
  end
end
