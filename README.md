<p align="center">
    <a href="https://github.com/DevelopersToolbox/">
        <img src="https://cdn.wolfsoftware.io/assets/images/github/organisations/developerstoolbox/black-and-white-circle-256.png" alt="DevelopersToolbox logo" />
    </a>
    <br />
    <a href="https://github.com/DevelopersToolbox/slackit/actions/workflows/ci.yml">
        <img src="https://img.shields.io/github/workflow/status/DevelopersToolbox/slackit/ci/master?style=for-the-badge" alt="Github Build Status">
    </a>
    <a href="https://github.com/DevelopersToolbox/slackit/releases/latest">
        <img src="https://img.shields.io/github/v/release/DevelopersToolbox/slackit?color=blue&label=Latest%20Release&style=for-the-badge" alt="Release">
    </a>
    <a href="https://github.com/DevelopersToolbox/slackit/releases/latest">
        <img src="https://img.shields.io/github/commits-since/DevelopersToolbox/slackit/latest.svg?color=blue&style=for-the-badge" alt="Commits since release">
    </a>
    <br />
    <a href=".github/CODE_OF_CONDUCT.md">
        <img src="https://img.shields.io/badge/Code%20of%20Conduct-blue?style=for-the-badge" />
    </a>
    <a href=".github/CONTRIBUTING.md">
        <img src="https://img.shields.io/badge/Contributing-blue?style=for-the-badge" />
    </a>
    <a href=".github/SECURITY.md">
        <img src="https://img.shields.io/badge/Report%20Security%20Concern-blue?style=for-the-badge" />
    </a>
    <a href="https://github.com/DevelopersToolbox/slackit/issues">
        <img src="https://img.shields.io/badge/Get%20Support-blue?style=for-the-badge" />
    </a>
    <br />
    <a href="https://wolfsoftware.io/">
        <img src="https://img.shields.io/badge/Created%20by%20Wolf%20Software-blue?style=for-the-badge" />
    </a>
</p>

## Overview

Slackit is a very simply Ruby Gem for posting to a slack incoming webhook.

It is now possible to send attachments and blocks however slackit doesn't take responsibility for creating those only for sending them. For more information on how to use those please refer to the Slack API documentation.

* [Attachments](https://api.slack.com/reference/messaging/attachments)
* [Blocks](https://api.slack.com/block-kit/building)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slackit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slackit

## Usage

```ruby
require "slackit"
```

### Initialize client

#### Initialize with minimal options

```ruby
client = Slackit.new(webhook_url: "slack webhook url")
```

#### Initialize with all options

```ruby
client = Slackit.new(
  webhook_url: "slack webhook url",
  channel: "#development",
  username: "mybot",
  icon_emoji: ":shipit:",
)
```

#### Initialize via shorthand method

```Ruby
client = Slackit.new(options)
```

#### Validating the webhook url

Firstly slackit will check to ensure that the webhook url starts with `https://hooks.slack.com/services`, this is the slack standard for all invalid webhook urls.

Secondly slackit will attempt to validate the webhook url, by making a HTTP `GET` request, if the response to the request is a redirect to `https://api.slack.com` then the url is deemed to be invalid.

This checking can be bypassed by supplying the `-V` command line option to tell slackit this is a `valid` url, this is useful if you know that the URL is valid and working and removes the additional overhead of repeated testing for each message.

If you want to manually validate a url you can do this using the command line option -v

```
slackit -v -w <slack webhook url>
```

This will run the GET test and also send a test message to the `general` channel to ensure that the supplied token is also valid, if this comes back with a success you `should` be safe to use the -V option from then on.

> Normal error handling during the post of a message will always be carried out.


### Sending Messages

#### Simple messages

```Ruby
client.send_message("This is a test message")
```

#### Attachments

```Ruby
client.send_attachment(attachment_json)
```
> NOTE: We will test to make sure the json is valid and catch errors thrown by the API for invalid formatting, missing values etc. General error from the api is `missing_text_or_fallback_or_attachments`

#### Blocks

```Ruby
client.send_block(block_json)
```

> NOTE: We will test to make sure the json is valid and catch errors thrown by the API for invalid formatting, missing values etc. General error from the api is `invalid_blocks_format`

### Command Line Usage

```
Usage: slackit
    -h, --help                       Display this screen
    -c, --channel string             The channel to send the message to
    -i, --icon-emoji string          The emoji to use for the channel icon [default: :wolf:]
    -m, --message string             The message to send
    -w, --webhook-url string         The slack incoming webhook url to use
    -u, --username string            The username to send as [default: slackit]

Webhook Validation:
    -v, --validation-test            Run a webbook validation test
    -V, --validated-webhook          Flag the webhook as validated (skips constant validation)

Message type options:
    -a, --attachment                 Treat the message as an attachment
    -b, --block                      Treat the message as a block
```

#### Pipe message

Alternatively to using the `-m` parameter, you can pipe your message instead:

    $ echo 'Hello world!' | slackit -w ...

#### Return values

For all sucessful sending slackit will return a value of 0. For all errors it will return the value of 1.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

For local testing make sure that you run `bundle exec rspec spec` and then `rake install` to install the gem locally.

