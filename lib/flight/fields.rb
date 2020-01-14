# frozen_string_literal: true

module Blinky
  module Flight
    # Shows fields for each repo
    class Fields
      extend Colors

      def self.run
        show_group_fields('Users', :users)
        show_group_fields('Tickets', :tickets)
        show_group_fields('Organizations', :organizations)
      end

      class << self
        def show_group_fields(name, group_key)
          puts '-' * 72
          puts "Search #{name} with:"
          puts Blinky::Constants::SCHEMAS[group_key].keys.collect { |key| "     #{key}" }
        end
      end
    end
  end
end
