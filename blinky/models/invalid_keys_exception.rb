module Blinky
  module Models
    # If the keys from the incoming row do not match the schemas keys
    class InvalidKeysException < StandardError
      def initialize(msg = 'You forget to add a message!')
        super
      end
    end
  end
end
