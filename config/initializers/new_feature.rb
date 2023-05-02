# frozen_string_literal: true
# -*- coding: UTF-8 -*-

Rails.application.configure do
  config.x.email_default_domain = ENV.fetch('EMAIL_DEFAULT_DOMAIN', '')
  config.x.email_regex = ENV.fetch('EMAIL_REGEX', nil)
  config.x.anon.tag = ((ENV.fetch('ANON_TAG', '[mask]')).dup).force_encoding('utf-8')
  config.x.anon.acc = ENV.fetch('ANON_ACC', nil)
  config.x.anon.namelist = ENV['ANON_NAME_LIST'] ? File.readlines(ENV['ANON_NAME_LIST']).collect(&:strip) : ['Alice', 'Bob', 'Carol', 'Dave']
  config.x.anon.salt = (1..42).map { ('a'..'z').to_a.sample }.join
  config.x.news_bot_id = ENV.fetch('NEWS_BOT', nil)
  config.x.disable_signup_notification = ENV['DISABLE_SIGNUP_NOTIFICATION'] == 'true'
end
