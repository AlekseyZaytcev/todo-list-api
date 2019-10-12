# frozen_string_literal: true

require 'dox'

RSpec.configure do |config|
  config.after(:each, :dox) do |example|
    example.metadata[:request] = request
    example.metadata[:response] = response
  end
end

Dox.configure do |config|
  config.header_file_path = Rails.root.join('spec', 'docs', 'v1', 'descriptions', 'header.md')
  config.desc_folder_path = Rails.root.join('spec', 'docs', 'v1', 'descriptions')

  # Requests and responses will by default list only Content-Type header.
  # To list other http headers, you must whitelist them.

  config.headers_whitelist = %w[Accept X-Auth-Token Authorization]
end
