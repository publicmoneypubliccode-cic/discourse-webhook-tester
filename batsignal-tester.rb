#!/usr/bin/env ruby
# all config is in
require 'discourse_api'
require 'date'
require 'dotenv'
Dotenv.load('test-env')

# set up client
client = DiscourseApi::Client.new(ENV['DISCOURSE_URL'])
client.api_key, client.api_username = ENV['DISCOURSE_API_KEY'], ENV['DISCOURSE_API_USER']

# create new topic on Discourse
begin
  client.create_topic(
    category: ENV['DISCOURSE_CATEGORY'],
    skip_validations: true,
    auto_track: false,
    title: ENV['BATSIGNAL_TEST_TITLE'] + " " + DateTime.now.strftime("%Y.%m.%d"),
    raw: ENV['BATSIGNAL_TEST_TEXT']
  )
rescue DiscourseApi::UnprocessableEntity => error
  # `body` is something like `{ errors: ["Name must be at least 3 characters"] }`
  # This outputs "Name must be at least 3 characters"
  # TODO email errors to admin
  puts error.response.body['errors'].first
end

# TODO email notification to admin
