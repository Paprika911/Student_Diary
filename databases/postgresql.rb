require 'pg'
require 'dotenv'

Dotenv.load(File.expand_path('./.env', __dir__))

module Databases
  class Postgresql
    def self.perform_query(query:, params: [])
      PG.connect(
        dbname: ENV.fetch('DB_NAME'),
        user: ENV.fetch('DB_USER'),
        password: ENV.fetch('DB_PASSWORD')
      ).exec_params(query, params).tap
    rescue PG::Error => e
      puts "Ошибка выполнения запроса: #{e.message}"
    ensure
      PG.connect.close if PG.respond_to?(:close)
    end
  end
end
