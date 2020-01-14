# frozen_string_literal: true

module Blinky
  module Persistence
    # Single access point for tickets
    class TicketsRepo
      extend AdapterDelegation
    end
  end
end
