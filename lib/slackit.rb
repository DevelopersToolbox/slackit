# frozen_string_literal: true

require 'slackit/version'
require 'net/http'
require 'uri'
require 'json'
require 'cmessages'

#
# To follow
#
class Slackit
    def initialize(options = {})
        @webhook_url       = options[:webhook_url]
        @username          = options[:username]
        @channel           = options[:channel]
        @icon_emoji        = options[:icon_emoji]

        @validation_test   = options[:validation_test]
        @validated_webhook = options[:validated_webhook]

        raise ArgumentError.new('Webhook URL required') if @webhook_url.nil?

        if @validation_test
            if valid_webhook(@webhook_url)
                @channel = 'general'
                send_message('This is a validation message')
                "#{@webhook_url} is a valid url".success
            else
                "#{@webhook_url} is NOT a valid url".error
            end
            return
        end

        raise ArgumentError.new("Invalid webhook URL: #{@webhook_url} - should start with https://hooks.slack.com/services/") unless @webhook_url.start_with?('https://hooks.slack.com/services/')

        return if valid_webhook(@webhook_url)

        raise ArgumentError.new("Invalid webhook URL: #{@webhook_url} - please check your configuration") unless valid_webhook(@webhook_url)
    end

    def valid_webhook(url)
        uri = URI.parse(url)

        r = Net::HTTP.get_response(uri)

        return false if (r.code == '301') || (r.code == '302')

        return true
    end

    #
    # Raw message
    #
    def send_message(text)
        text = text.gsub('\\n', "\n") # ensure newlines are not escaped

        payload = { 'text' => text }

        return send_payload(payload)
    end

    #
    # Add an alias for backwards compatibility
    #
    def send(text)
        return send_message(text)
    end

    #
    # Legacy attachments
    #
    def send_attachment(attachment)
        payload = { 'attachments' => [ convert_to_json(attachment) ] }
        return send_payload(payload)
    end

    #
    # New shiney blocks
    #
    def send_block(block)
        payload = convert_to_json(block)
        return send_payload(payload)
    end

    #
    # Convery the string to json
    #
    def convert_to_json(json_string)
        begin
            return JSON.parse(json_string)
        rescue JSON::ParserError
            raise ArgumentError.new('Invalid json')
        end
    end

    def send_payload(payload)
        headers = { 'Content-Type' => 'application/json' }

        # Add the additional payload items
        payload['icon_emoji'] ||= @icon_emoji
        payload['username'] ||= @username
        payload['channel'] ||= @channel

        begin
            uri = URI.parse(@webhook_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.request_uri, headers)
            request.body = payload.to_json
            response = http.request(request)

            return true if response.code == '200'

            raise "Invalid webhook URL: #{@webhook_url} - please check your configuration" if response.code == '301' || response.code == '302'

            raise "Unknown error for webhook URL: #{@webhook_url}" if response.body.empty?

            raise response.body
        rescue Exception => e
            raise e
        end
    end
end
