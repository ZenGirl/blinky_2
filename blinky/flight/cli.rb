module Blinky
  class CLI
    extend Blinky::Flight::Colors

    def self.run
      set_colors
      banner
      @data = Blinky::PreFlight::Organizers::Engine.call
      unless @data.success?
        puts 'Errors occurred during load:'
        puts @data.message
        puts @data.errors
        puts "\nBye"
        exit 1
      end
      help
      prompt
      while (phrase = gets.chomp)
        cmd = phrase.squeeze(' ').downcase.split(' ')[0]
        break if cmd == 'quit'
        if cmd == '1'
          Blinky::Flight::Search.run(@data)
          help
        elsif cmd == '2'
          Blinky::Flight::Fields.run
          help
        elsif cmd == 'help'
          help
        else
          unknown_command(cmd)
        end
        prompt
      end
      puts "\nBye"
    end

    private

    def self.unknown_command(cmd)
      puts "The command [#{cmd}] is unknown"
      help
    end

    def self.banner
      puts 'Welcome to Blinky search!'
      puts 'A simple CLI for search for a coding challenge.'
    end

    def self.help
      puts ''
      puts "Type #{@red_on}quit [enter]#{@color_off} to exit at any time."
      puts "Type #{@red_on}help [enter]#{@color_off} to view this message."
      puts ''
      puts '        Select search options:'
      puts '        * Type 1 to search'
      puts '        * Type 2 to view a list of searchable fields'
      puts ''
    end

    def self.prompt
      print "#{@blue_on} > #{@color_off}"
    end
  end
end
