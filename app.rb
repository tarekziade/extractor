#
# Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
# or more contributor license agreements. Licensed under the Elastic License;
# you may not use this file except in compliance with the Elastic License.
#

# frozen_string_literal: true

require 'hashie'
require 'json'

require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'open-uri'
require 'pdf-reader'


# Sinatra app
class ConnectorsWebApp < Sinatra::Base
  register Sinatra::ConfigFile
  config_file File.join(__dir__, 'config.yml')

  configure do
    set :raise_errors, false
    set :show_exceptions, false
    set :bind, settings.http['host']
    set :port, settings.http['port']
  end

  get '/extract' do
    io = open('https://www.orphoz.com/uploads/media/pdf-exemple.pdf')
    reader = PDF::Reader.new(io)

    pages = reader.pages.each do |page|
      page.text
    end

    json(
      :info => reader.info,
      :pages => pages
    )
  end
end
