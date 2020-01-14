# frozen_string_literal: true

module Blinky
  module Persistence
    # Single access point for organizations
    class OrganizationsRepo
      extend AdapterDelegation
    end
  end
end
