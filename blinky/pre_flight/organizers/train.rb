# frozen_string_literal: true

module Blinky
  module PreFlight
    module Organizers
      # Ensures all pieces are in place before starting actual process
      class Train
        include Interactor::Organizer

        organize Interactors::ValidEnvVariables,
                 Interactors::ValidReadableFiles,
                 Interactors::ValidJsonFiles,
                 Interactors::LoadUsers
      end
    end
  end
end
