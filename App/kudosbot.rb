require 'slack'
require_relative '../Database/db_interaction'

include DBInt

# API token
@token = ENV['SLACK_API_TOKEN']

# Create a new realtime client
client = Slack::RealTime::Client.new(token: @token)

# Initialize database object
init_db_object

# Start the realtime server
client.on :hello do
  puts "Successfully connected, to the team at https://#{client.team.domain}.slack.com."
end

# Deals with realtime messages
client.on :message do |data|
  case data.text
  when 'kudos help' then
    client.web_client.chat_postMessage(
      channel: data.channel,
      as_user: true,
      text: 'Here you go',
      attachments: [
        {
          "color": "#3AA3E3",
          "fields": [
            {
              "title": "Create a new appreciation",
              "value": "kudos &lt;@username1 @username2...&gt; &lt;Core Value&gt; &lt;Appreciation Message&gt;"
            },
            {
              "title": "Get Leaderboard",
              "value": "kudos leaderboard"
            },
            {
              "title": "Get Giverboard",
              "value": "kudos giverboard"
            },
            {
              "title": "Get Your Stats",
              "value": "kudos stats"
            }
          ],
          "footer": "KudosBot",
          "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
        }
      ]
    )
  when 'kudos leaderboard' then
    board = get_leaderboard
    fields_arr = []
    board.each do |hash|
      fields_arr.push({ "value": "<@#{hash.keys.join()}> : #{hash.values.join()}" })
    end
    client.web_client.chat_postMessage(
      channel: data.channel,
      text: "*Leaderboard* :trophy: :clap:",
      as_user: true,
      attachments: [
        {
          "color": "#36a64f",
          "fields": fields_arr,
          "footer": "KudosBot",
          "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
        }
      ]
    )
  when 'kudos giverboard' then
    board = get_giverboard
    fields_arr = []
    board.each do |hash|
      fields_arr.push({ "value": "<@#{hash.keys.join()}> : #{hash.values.join()}" })
    end
    client.web_client.chat_postMessage(
      channel: data.channel,
      text: "*Giverboard* :+1:",
      as_user: true,
      attachments: [
        {
          "color": "#36a64f",
          "fields": fields_arr,
          "footer": "KudosBot",
          "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
        }
      ]
    )
  when /kudos &lt;.*&gt;/ then
    @data_array = data.text.gsub(/kudos /, '').split(/&lt;|&gt;/).map(&:strip).reject(&:empty?)
    @user_names = @data_array[0].split(/, | |,/).each { |name| name.gsub!(/@|<|>/, '') }
    @core_value = @data_array[1]
    @kudos_text = @data_array[2]
    sparkle = ':tada: :sparkles: :boom:'
    client.web_client.chat_postMessage(
      channel: data.channel,
      text: "*Hooray!!!* #{@data_array[0]} #{sparkle} _you received an appreciation from_ <@#{data.user}> :trophy: :clap:",
      as_user: true,
      attachments: [
        {
          "color": "#36a64f",
          "fields": [
            {
              "title": "For Core Value:",
              "value": "#{@core_value}"
            },
            {
              "title": "Message:",
              "value": "#{@kudos_text}"
            }
          ],
          "footer": "KudosBot",
          "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
        }
      ]
    )
    @user_names.each do |individual_user|
      update_details(
        createdby: data.user,
        performer: individual_user,
        core_value: @core_value,
        message: @kudos_text
      )
    end
  end
end

# Log a message when client is disconnected
client.on :closed do |_data|
  puts "Client has disconnected successfully!"
end

client.start!
