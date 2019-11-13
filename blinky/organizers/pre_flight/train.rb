module Blinky
  module Organizers
    module PreFlight
      # Ensures all pieces are in place before starting actual process
      class Train
        include Interactor::Organizer

        organize ValidEnvVariables, ValidReadableFiles, ValidJsonFiles
      end
    end
  end
end
