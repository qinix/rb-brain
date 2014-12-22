require 'rspec'

Dir['spec/supports/**/*.rb'].each { |f| require File.expand_path(f) }

require 'brain'

RSpec.configure do |config|
  config.include Helpers
end

