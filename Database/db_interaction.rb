require 'sqlite3'

# Module which holds DB handling related stuffs
module DBInt
  # Method to initialize object for connecting to database
  def init_db_object
    # Create a Database object
    @db = SQLite3::Database.open('kudos_bot.db')
  end

  # Method to update details in databse
  #
  # @param params [Hash] hash of column names and their
  #   corresponding values to be updated
  def update_details(**params)
    columns = []
    values = []
    params.each do |key, value|
      columns.push(key.to_s)
      values.push("'#{value.to_s}'")
    end
    @db.query("insert into kudos (#{columns.join(',')}) values (#{values.join(',')})")
  end

  # Method to get stats for an individual user
  #
  # @param user: [String] user id of the user
  #
  # @return [Hash] hash containing given and received count
  def get_stats(
      user:
    )
    result = {}
    # Get the given details from database.
    result['Given'] = @db.execute(
      "select count(*) from kudos where createdby = '#{user}'"
    ).join
    # Get the received details from database
    result['Received'] = @db.execute(
      "select count(*) from kudos where performer = '#{user}'"
    ).join
    # Return result
    result
  end

  # Method to get the leaderboard details
  #
  # @return Array of Hash containing the details of leaderboard
  def get_leaderboard
    get_board_details(who: 'performer')
  end

  # Method to get the giverboard details
  #
  # @return Array of Hash containing the details of giverboard
  def get_giverboard
    get_board_details(who: 'createdby')
  end

  # Method to fetch details board details from the db as per the
  # requirements
  #
  # @param who: [String] column name of who (Mostly 'performer' or 'createdby')
  #
  # @return [Array of Hash] board details
  def get_board_details(
      who:
    )
    result = Array.new { Hash.new }
    # In Default take last 30 days of record
    data = @db.execute(
      "select distinct #{who} from kudos where created >= datetime('now', '-30 days')"
    )
    data.each do |single_user|
      user = single_user.join
      temp = @db.execute(
        "select count(*) from kudos where #{who} = '#{user}' and created >= datetime('now', '-30 days')"
      ).join
      result.push("#{user}" => temp)
    end
    # Return result as an Array of Hash
    result
  end
end
