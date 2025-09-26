#!/bin/bash

# Exit on error
set -e

# Install dependencies
bundle install

# Create database
rails db:create

# Run migrations
rails db:migrate

# Run tests
rspec
