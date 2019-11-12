require 'interactor'

require 'blinky_2/constants'

module Blinky2

  module Organizers

    # Ensures all pieces are in place before starting actual process
    class PreFlightTrain
      include Interactor::Organizer

      organize ValidEnvVariables, ValidReadableFiles, ValidJsonFiles
    end

  end
end
