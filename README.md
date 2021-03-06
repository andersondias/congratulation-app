# Congratulation Slack Command App

This is a sample implementation to test Slack Command API.

It's composed by a basic Sinatra application that receives a POST message in the /slack/command path, authorizes it, parses the params and returns the response to the sender if the congratulation was correctly sent.

You can find more detailed information about this project at:
- https://medium.com/little-programming-joys/slack-command-api-with-ruby-part-1-3a299bc1591c
- https://medium.com/little-programming-joys/introduction-dc968783dae0

Also, read the commit history to understand how it has evolved, step by step.

## Slack Command

Commands enable users to interact with your app from within Slack. This application respond to the following command structure:

```
/congratulate @john for his new product release! It's brilliant!
```

It has a command (/congratulate), a receiver (@john) followed by a message.

This command is sent via a POST request like bellow:


```
{"token"=>"XXXXX", "team_id"=>"YYYY", "team_domain"=>"ZZZZ", "channel_id"=>"UUUU", "channel_name"=>"directmessage", "user_id"=>"AAA", "user_name"=>"anderson", "command"=>"/congratulate", "text"=>"@john  for his new product release! It's brilliant!", "response_url"=>"https://hooks.slack.com/commands/YYYY/DDDDDDDDDDD/HASH"}
```

## The Slack App

The app consists of two components:
 - Slach Commands
 - Permissions

The commands are pointed to https://congratulate.herokuapp.com/slack/command.

And it has two permissions:
 - commands: in order to receive slack commands
 - chat:write:bot: in order to send messages as the application.

## The Sinatra Application

It's this application and it's running at https://congratulate.herokuapp.com/.

It responds to one route /slack/command and it's secured by the slack application token sent via post (see SlackAuthorizer class).

In order to be able to receive any information from slack you must setup SLACK_TOKEN env var and send the same value in the post token data.

The command invoker must receive a response if the command was valid or not and the congratulated user must receive a notification.

### Messaging to another user

In order to send a message to the receiver the application needs to use the https://slack.com/api/chat.postMessage API.

This API requires us a specific OAuth token to be used and it can be found at https://api.slack.com/apps/XXX/oauth.

Also it requires the chat:write:bot permission.

We send the message via curl, using spawn, a ruby async call to system functions, so there is no process block and no need to use paid workers at heroku. ;)

See SlackMessenger class.

## Running it locally

In order to run the sinatra app you must declare the ENV vars before the rackup:

```
SLACK_TOKEN='XXX' SLACK_OAUTH='YYY' rackup -p 4567
```

## TODO

* Improve specs related to HTTPClient requests;
* Do not allow users to send congratulations to themselves;
* Validates if the congratulated username is valid;
* Send the direct message asynchronously to prevent slow response times.


