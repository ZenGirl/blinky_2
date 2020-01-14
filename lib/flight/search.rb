# frozen_string_literal: true

module Blinky
  module Flight
    # Encapsulates the search operations
    class Search
      extend Colors

      TARGET_DATA = {
        '1' => { key: :users, repo: Blinky::Persistence::UsersRepo, view: Blinky::Views::User },
        '2' => { key: :tickets, repo: Blinky::Persistence::TicketsRepo, view: Blinky::Views::Ticket },
        '3' => { key: :organizations, repo: Blinky::Persistence::OrganizationsRepo, view: Blinky::Views::Organization }
      }.freeze

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def self.run
        set_colors
        search_prompt
        while (phrase = gets.chomp)
          # Get main choice
          cmd = phrase.squeeze(' ').downcase.split(' ')[0]
          break if cmd == '4'

          unless %w[1 2 3].include?(cmd)
            puts "#{@yellow_on}The command [#{cmd}] is unknown#{@color_off}"
            search_prompt
            next
          end

          # Target specific repo
          target       = TARGET_DATA[cmd]
          dataset      = target[:key].to_s.capitalize
          valid_fields = Blinky::Constants::SCHEMAS[target[:key]]
          # Get field
          field = get_field(dataset, valid_fields)
          if field.nil?
            search_prompt
            next
          end

          # Get criteria
          coerced_value = get_criteria(field, dataset, valid_fields)
          next if coerced_value.nil?

          # Perform Search
          perform_search(target, field, coerced_value)
          # Continue
          search_prompt
        end
      end

      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      class << self
        def get_field(dataset, valid_fields)
          field_names = valid_fields.keys.collect(&:to_s)
          puts "#{@purple_on}Enter search field for #{dataset} (? shows fields)#{@color_off}"
          print "#{@purple_on} > #{@color_off}"
          while (phrase = gets.chomp)
            field = phrase.squeeze(' ').downcase.split(' ')[0]
            if field == '?'
              puts "#{@purple_on}#{field_names}#{@color_off}"
              print "#{@purple_on} > #{@color_off}"
              next
            end
            unless field_names.include?(field)
              puts "#{@purple_on}The field [#{field}] is unknown#{@color_off}"
              return nil
            end
            break
          end
          field
        end

        # rubocop:disable Metrics/AbcSize
        def get_criteria(field, dataset, valid_fields)
          puts "#{@purple_on}Enter search value#{@color_off}"
          print "#{@purple_on} > #{@color_off}"
          value = gets.chomp.squeeze(' ').strip
          puts "#{@purple_on}Searching #{dataset} for #{field} with a value of '#{value}'#{@color_off}"
          field_type = valid_fields[field.to_sym][:type]
          if %I[guid url datetime string regex array].include? field_type
            value.to_s
          elsif field_type == :integer
            value.to_i
          elsif field_type == :boolean
            value.to_s == 'true'
          else
            puts "Unknown field_type: [#{field_type}]"
            nil
          end
        end

        # rubocop:enable Metrics/AbcSize

        # rubocop:disable Layout/ExtraSpacing, Layout/SpaceAroundOperators
        def perform_search(target, field, coerced_value)
          mode     = :equal
          mode     = :like if coerced_value.is_a?(String) && coerced_value.index('*')
          criteria = {
            mode:        mode,
            field.to_sym => coerced_value
          }
          results  = target[:repo].query(criteria)
          if results&.size.positive?
            results.each do |result|
              puts target[:view].new.render(result, true)
            end
          else
            puts 'No results found'
          end
        end

        # rubocop:enable Layout/ExtraSpacing, Layout/SpaceAroundOperators

        def search_prompt
          puts "#{@yellow_on}Select 1) Users or 2) Tickets or 3) Organizations or 4) exit to main menu.#{@color_off}"
          print "#{@yellow_on} > #{@color_off}"
        end
      end
    end
  end
end
