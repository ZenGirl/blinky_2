module Blinky
  module Schemas
    # Defines the schema for a tickets object
    # Provides validation for a string
    class Tickets
      attr_reader :schema

      def initialize
        @schema = Blinky::Constants::SCHEMAS[:ticket]
      end

      def validate(file_name)
        true
      end
    end
  end
end
