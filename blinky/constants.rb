module Blinky

  module Constants

    ENV_VAR_NAMES = %w[TICKETS USERS ORGANISATIONS].freeze

    # Disabled because it shows irritating message which provides no perceivable benefit
    # rubocop:disable Layout/AlignHash
    MESSAGES = {
      not_present:  'environment variable is not present',
      not_usable:   'environment variable is blank',
      not_readable: 'does not name a readable file'
    }.freeze

  end

end
