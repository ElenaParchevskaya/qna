# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  # DatabaseCleaner settings
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
    # Index data when running an acceptance spec.
    DatabaseCleaner.start
  end
end
