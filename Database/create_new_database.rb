require 'sqlite3'

# Create database object
db = SQLite3::Database.new('kudos_bot.db')

# Create a new table
db.execute <<-SQL
        create table kudos(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                performer VARCHAR(40),
                core_value VARCHAR(40),
                message VARCHAR(400),
                createdby VARCHAR(40),
                created DATETIME DEFAULT CURRENT_TIMESTAMP
        );
SQL
