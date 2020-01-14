# frozen_string_literal: true

$LOAD_PATH << File.expand_path('blinky', __dir__)

require 'erb'
require 'json'
require 'time'

require 'interactor'
require 'j_formalize'

require 'constants'
require 'utils'

require 'persistence/adapters/in_memory'
require 'persistence/adapter_delegation'
require 'persistence/users_repo'
require 'persistence/tickets_repo'
require 'persistence/organizations_repo'

require 'pre_flight/interactors/valid_env_variables'
require 'pre_flight/interactors/valid_readable_files'
require 'pre_flight/interactors/formalize'
require 'pre_flight/interactors/load_data'
require 'pre_flight/organizers/engine'

require 'views/master_view'

require 'views/ticket'
require 'views/ticket_partial'
require 'views/user'
require 'views/user_partial'
require 'views/organization'
require 'views/organization_partial'

trap('SIGINT') do
  puts "\nBye"
  exit 0
end

require 'flight/colors'
require 'flight/search'
require 'flight/fields'
require 'flight/cli'

Blinky::CLI.run
