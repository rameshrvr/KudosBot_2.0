require 'http'
require 'json'

result = HTTP.post(
  'https://slack.com/api/chat.postMessage',
  params: {
    token: 'xoxb-263971807829-z1yjgA1utAZSHJsOq9M51LZg',
    channel: 'slack-bot-test',
    text: 'Test Message',
    as_user: 'slackbot'
  }
)

puts JSON.pretty_generate(JSON.parse(result.body))
