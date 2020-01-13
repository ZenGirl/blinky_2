# frozen_string_literal: true

module Blinky
  module Persistence
    # Single access point for users
    class UsersRepo
      extend AdapterDelegation
    end
  end
end
