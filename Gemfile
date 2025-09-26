source "https://rubygems.org"

ruby "3.3.7"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.3"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
gem "solid_cache"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Sidekiq for background jobs
gem "sidekiq"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# For S3 storage
gem "aws-sdk-s3", require: false

# For text extraction
gem "pdf-reader"
gem "docx"

# For vector similarity search
gem "pgvector"

# For OpenAI API
gem "ruby-openai"

# For user authentication
gem "devise"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 6.0.0"
  gem "factory_bot_rails"
end

group :development do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

