module Blinky
  module Flight
    class Search
      extend Colors

      TARGET_DATA  = {
        '1' => { key: :users, repo: Blinky::Persistence::UsersRepo, view: Blinky::Views::User },
        '2' => { key: :tickets, repo: Blinky::Persistence::TicketsRepo, view: Blinky::Views::Ticket },
        '3' => { key: :organizations, repo: Blinky::Persistence::OrganizationsRepo, view: Blinky::Views::Organization }
      }

      def self.run(data)
        set_colors
        search_prompt
        while (phrase = gets.chomp)
          # Get main choice
          cmd = phrase.squeeze(' ').downcase.split(' ')[0]
          break if cmd == '4'
          unless %w(1 2 3).include?(cmd)
            puts "#{@yellow_on}The command [#{cmd}] is unknown#{@color_off}"
            search_prompt
            next
          end
          # Target specific repo
          target       = TARGET_DATA[cmd]
          dataset      = target[:key].to_s.capitalize
          valid_fields = Blinky::Constants::SCHEMAS[target[:key]]
          # Get field
          field = get_field(valid_fields)
          next if field.nil?
          # Get criteria
          coerced_value = get_criteria(field, dataset, valid_fields)
          next if coerced_value.nil?
          # Perform Search
          perform_search(target, field, coerced_value)
          # Continue
          search_prompt
        end
      end

      private

      def self.get_field(valid_fields)
        puts "#{@purple_on}Enter search field#{@color_off}"
        print "#{@purple_on} > #{@color_off}"
        phrase = gets.chomp
        field  = phrase.squeeze(' ').downcase.split(' ')[0]
        unless valid_fields.keys.include?(field.to_sym)
          puts "#{@purple_on}The field [#{field}] is unknown#{@color_off}"
          search_prompt
          return nil
        end
        field
      end

      def self.get_criteria(field, dataset, valid_fields)
        puts "#{@purple_on}Enter search value#{@color_off}"
        print "#{@purple_on} > #{@color_off}"
        phrase = gets.chomp
        value  = phrase.squeeze(' ').downcase.split(' ')[0]
        puts "#{@purple_on}Searching #{dataset} for #{field} with a value of #{value}#{@color_off}"
        field_type    = valid_fields[field.to_sym][:type]
        coerced_value = if [:guid, :url, :datetime, :string].include? field_type
                          value.to_s
                        elsif [:integer].include? field_type
                          value.to_i
                        elsif [:boolean].include? field_type
                          value.to_i
                        else
                          puts "Unknown field_type: [#{field_type}]"
                          nil
                        end
        coerced_value
      end

      def self.perform_search(target, field, coerced_value)
        criteria      = {
          mode:        :equal,
          field.to_sym => coerced_value
        }
        results       = target[:repo].query(criteria)
        if results && results.size > 0
          results.each do |result|
            puts target[:view].new.render(result, true)
          end
        else
          puts 'No results found'
        end
      end

      def self.search_prompt
        puts "#{@yellow_on}Select 1) Users or 2) Tickets or 3) Organizations or 4) exit to main menu.#{@color_off}"
        print "#{@yellow_on} > #{@color_off}"
      end
    end
  end
end
