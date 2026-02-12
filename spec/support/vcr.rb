require 'vcr'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  # config.debug_logger = $stderr
  config.cassette_library_dir = Rails.root.join('spec', 'cassettes')
  config.ignore_localhost = true
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = {
    match_requests_on: [:method, :uri, :body]
  }
  config.before_record do |interaction|
    interaction.request.headers['Authorization'] = '[FILTERED]'
    interaction.request.headers['key'] = '[FILTERED]'
  end

  RSpec.configure do |config|
    config.around(:each) do |example|
      options = example.metadata[:vcr] || {}
      options[:allow_playback_repeats] = true
      
      if options[:record] == :skip
        VCR.turned_off(&example)
      else
        custom_name = example.metadata[:vcr]&.delete(:cassette_name)
        generated_name = example.metadata[:full_description]
          .split(/\s+/, 2)
          .join('/')
          .underscore
          .tr('.','/')
          .gsub(/[^\w\/]+/, '_')
          .gsub(/\/$/, '')
        name = custom_name || generated_name
        VCR.use_cassette(name, options, &example)
      end
    end
  end
end
