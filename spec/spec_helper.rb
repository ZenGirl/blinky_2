# NOTE:
# clear; bundle exec rspec

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'interactor'
require 'awesome_print'

$LOAD_PATH << File.expand_path('.')

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
# RSpec.configure do |config|
#   config.expect_with :rspec do |expectations|
#     expectations.syntax = :expect
#   end
# end
# RSpec.configure do |config|
#   original_stderr = $stderr
#   original_stdout = $stdout
#   config.before(:all) do
#     Redirect stderr and stdout
    # $stderr = File.open(File::NULL, 'w')
    # $stdout = File.open(File::NULL, 'w')
  # end
  # config.after(:all) do
  #   $stderr = original_stderr
  #   $stdout = original_stdout
  # end
# end
