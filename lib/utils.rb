# frozen_string_literal: true

module Blinky
  # Simple set of common methods
  module Utils
    def err(key)
      Blinky::Constants::MESSAGES[key]
    end
  end
end
