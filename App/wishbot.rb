require 'slack'
require_relative 'db_interaction'

include DBInt

# API token
@token = ENV['SLACK_API_TOKEN']

# Create a new client
client = Slack::RealTime::Client.new(token: @token)

# Initialize database object
init_db_object

# Start the realtime server
client.on :hello do
  puts "Successfully connected, to the team at https://#{client.team.domain}.slack.com."
end

# Deals with realtime messages
client.on :message do |data|
  if data.text.include?('kudos ')
    @data_array = data.text.gsub(/kudos /, '').split(/'|'/).map(&:strip).reject(&:empty?)
    @user_names = @data_array[0].split(/, | |,/).each { |name| name.gsub!(/@/, '') }
    @core_value = @data_array[1]
    @kudos_text = @data_array[2]
    update_details(
      giver: data.user,
      getter: @user_names.join(','),
      core_value: @core_value,
      message: @kudos_text
    )
    client.message(channel: data.channel, text: "Successfully Updated")
  end
end

client.on :close do |_data|
  puts "Client is about to disconnect"
end

client.on :closed do |_data|
  puts "Client has disconnected successfully!"
end

client.start!
