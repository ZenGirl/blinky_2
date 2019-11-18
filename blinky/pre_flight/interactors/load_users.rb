# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # At this point, the context should hold the file names
      # and those files should be validated as existing, readable
      # and match the generic JSON schema regex.
      # So, now we attempt to load the users file
      class LoadUsers
        include Interactor
        include Utils

        def call

        end

        private

      end
    end
  end
end
