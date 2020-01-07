# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Ensures that the files provide are actually JSON and loads formalized objects
      class ValidJsonFiles
        include Interactor
        include Utils

        # noinspection RubyResolve
        def call
          context.tickets       = validate_and_formalize(:tickets, context.tickets_file)
          context.users         = validate_and_formalize(:users, context.users_file)
          context.organizations = validate_and_formalize(:organizations, context.organizations_file)
        end

        private

        def validate_and_formalize(key, file_name)
          ctx    = {
              json_string: load_file(key, file_name),
              max_size:    nil,
              schema:      Blinky::Constants::SCHEMAS[key]
          }
          result = ::JFormalize::Engine.call(ctx)
          context.fail!(message: "#{key} #{file_name} #{result.message}") unless result.success?
          result.formalized_objects
        end

        def load_file(key, file_name)
          json_string = ''
          begin
            json_string = IO.read(file_name, mode: 'r')
          rescue IOError => e
            context.fail!(message: "#{key} #{file_name} #{err(:env_var_file_error)} #{e}")
          rescue StandardError => e
            context.fail!(message: "#{key} #{file_name} #{err(:env_var_file_error)} #{e}")
          end
          json_string
        end
      end
    end
  end
end
