require 'mysql2'

module DBInt
  def init_db_object
    # Create a Database object
    @db = Mysql2::Client.new(
      host: 'localhost',
      username: ENV['SQL_USERNAME'],
      password: ENV['SQL_PASSWORD'],
      database: 'kudos_bot'
    )
  end

  def update_details(**params)
    columns, values = [], []
    params.each do |key, value|
      columns.push(key.to_s)
      values.push("'#{value.to_s}'")
    end
    @db.query("insert into bot_data (#{columns.join(',')}) values (#{values.join(',')})")
  end
end
