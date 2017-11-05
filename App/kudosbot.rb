require_relative '../Database/db_interaction'

class KudosBot
  include DBInt
  # Method to initialize the realtime client
  def initialize(token:)
    @client = Slack::RealTime::Client.new(token: token)
    init_db_object
  end

  # Method to post help message
  def post_help_message(
      data:
    )
    text = 'Here you go'
    color = "#3AA3E3"
    fields = [
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
    ]
    _web_client_post_message(data: data, text: text, color: color, fields: fields)
  end

  # Method to post stats message
  def post_stats_message(
      data:
    )
    stats = get_stats(user: data.user)
    fields = []
    stats.each do |key, value|
      fields.push({ "value": "#{key} #{value} Appreciations"})
    end
    text = "*Your Stats*"
    _web_client_post_message(data: data, text: text, fields: fields)
  end

  # Method to post leaderboard
  def post_leaderboard_message(
      data:
    )
    board = get_leaderboard
    fields = []
    board.each do |hash|
      fields.push({ "value": "<@#{hash.keys.join()}> : #{hash.values.join()}" })
    end
    text = "*Leaderboard* :trophy: :clap:"
    _web_client_post_message(data: data, text: text, fields: fields)
  end

  # Method to post giverboard
  def post_giverboard_message(
      data:
    )
    board = get_giverboard
    fields = []
    board.each do |hash|
      fields.push({ "value": "<@#{hash.keys.join()}> : #{hash.values.join()}" })
    end
    text = "*Giverboard* :+1:"
    _web_client_post_message(data: data, text: text, fields: fields)
  end

  # Method to post kudos message
  def post_kudos_message(
      data:
    )
    @data_array = data.text.gsub(/kudos /, '').split(/&lt;|&gt;/).map(&:strip).reject(&:empty?)
    @user_names = @data_array[0].split(/, | |,/).each { |name| name.gsub!(/@|<|>/, '') }
    text = "*Congrats!!!* #{@data_array[0]} :tada: :sparkles: :boom: _you received an appreciation from_ <@#{data.user}> :trophy: :clap:"
    fields = [
      {
        "title": "For Core Value:",
        "value": "#{@data_array[1]}"
      },
      {
        "title": "Message:",
        "value": "#{@data_array[2]}"
      }
    ]
    _web_client_post_message(data: data, text: text, fields: fields)
    @user_names.each do |individual_user|
      update_details(
        createdby: data.user,
        performer: individual_user,
        core_value: @data_array[1],
        message: @data_array[2]
      )
    end
  end

  # Private method to post message via webclient
  def _web_client_post_message(
      data:,
      text:,
      color: '#36a64f',
      fields:
    )
    @client.web_client.chat_postMessage(
      channel: data.channel,
      as_user: true,
      text: text,
      attachments: [
        {
          "color": color,
          "fields": fields,
          "footer": "KudosBot",
          "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
        }
      ]
    )
  end
end
