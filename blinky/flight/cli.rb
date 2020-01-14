# frozen_string_literal: true

module Blinky
  # The main command line interface
  class CLI
    extend Blinky::Flight::Colors

    # rubocop:disable Metrics/AbcSize
    def self.run
      set_colors
      banner
      load_and_check
      help
      prompt
      while (phrase = gets.chomp)
        cmd = phrase.squeeze(' ').downcase.split(' ')[0]
        break if cmd == 'quit'

        if cmd == '1'
          Blinky::Flight::Search.run
        elsif cmd == '2'
          Blinky::Flight::Fields.run
        elsif cmd == 'help'
        # Nothing to do - falls out to help
        else
          puts "The command [#{cmd}] is unknown"
        end
        help
        prompt
      end
      puts "\nBye"
    end
    # rubocop:enable Metrics/AbcSize

    class << self
      def load_and_check
        result = Blinky::PreFlight::Organizers::Engine.call
        return if result.success?

        puts 'Errors occurred during load:'
        puts result.message
        puts result.errors
        puts "\nBye"
        exit 1
      end

      def banner
        puts 'Welcome to Blinky search!'
        puts 'A simple CLI for search for a coding challenge.'
      end

      def help
        puts ''
        puts "Type #{@red_on}quit [enter]#{@color_off} to exit at any time."
        puts "Type #{@red_on}help [enter]#{@color_off} to view this message."
        puts ''
        puts '        Select search options:'
        puts '        * Type 1 to search datasets (Users, Tickets or Organizations)'
        puts '        * Type 2 to view a list of searchable fields'
        puts ''
      end

      def prompt
        print "#{@blue_on} > #{@color_off}"
      end
    end
  end
end
