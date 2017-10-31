require 'http'
require 'json'

result = HTTP.post(
  'https://slack.com/api/chat.postMessage',
  params: {
    token: token,
    channel: 'slack-bot-test',
    text: 'Test Message',
    as_user: 'slackbot'
  }
)

puts JSON.pretty_generate(JSON.parse(result.body))