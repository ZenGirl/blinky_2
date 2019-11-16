# frozen_string_literal: true

module Blinky
  # Simple set of common methods
  module Utils
    def format_error(prefix, msg_sym, interstitial, suffix)
      # prefix = "#{prefix} " if prefix.length > 0 && interstitial.length <= 0
      "Error: #{prefix}#{interstitial} #{Blinky::Constants::ERROR_MESSAGES[msg_sym]}#{suffix}"
    end

    def fail_with_msg(env_var, msg_sym, interstitial, suffix)
      context.error = format_error(env_var, msg_sym, interstitial, suffix)
      context.fail!
    end

  end
end
