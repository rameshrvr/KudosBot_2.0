# WishBot

A Slack bot that helps to appreciate team members. It also helps us to track the appreciation history and leaderboard, giverboard, stats when ever needed.

## Installation

Clone this repositary.

```
git clone https://github.com/rameshrvr/KudosBot_2.0.git
```

Run `bundle install`.

## Usage

### Create a New Bot Integration

This is something done in Slack, under [integrations](https://my.slack.com/services). Create a [new bot](https://my.slack.com/services/new/bot), and note its API token.

![](Assets/Images/register-bot.png)


### Settings

If you are using a linux machine

```
export SLACK_API_TOKEN={your slack app api token}
```

If you are using a windows machine

```
SET SLACK_API_TOKEN={your slack app api token}
```

Create a new database using the below comment (You can edit your database name, table name, column values in create_new_database.rb)

```
ruby Database/create_new_database.rb
```

### Start Application

Start the server using the below comment

```
ruby Server/start_server.rb
```

### Examples

#### To see all supported commands (help)

<img src='https://github.com/rameshrvr/KudosBot_2.0/blob/master/Assets/Images/Kudos_help.png' height="75%" width="75%">

#### Giving appreciations to team members

<img src='https://github.com/rameshrvr/KudosBot_2.0/blob/master/Assets/Images/Kudos_new.png' height="75%" width="75%">

#### View Leaderboard

<img src='https://github.com/rameshrvr/KudosBot_2.0/blob/master/Assets/Images/Kudos_leaderboard.png' height="75%" width="75%">

#### View Giverboard

<img src='https://github.com/rameshrvr/KudosBot_2.0/blob/master/Assets/Images/Kudos_giverboard.png' height="75%" width="75%">

#### View your stats

<img src='https://github.com/rameshrvr/KudosBot_2.0/blob/master/Assets/Images/Kudos_stats.png' height="75%" width="75%">
