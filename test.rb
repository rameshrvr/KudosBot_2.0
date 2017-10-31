require 'slack'

# Create a new client
client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])

client.auth_test
