# frozen_string_literal: true

module Blinky
  module PreFlight
    module Interactors
      # Ensures that the files provide are actually JSON and loads formalized objects
      class Formalize
        include Interactor
        include Utils

        def call
          data = context.data
          data.keys.each do |key|
            data[key][:formalized_objects] = validate_and_formalize key, data[key][:file]
          end
        end

        private

        def formalize_context(key, file_name)
          {
            json_string: load_file(key, file_name),
            max_size:    200_000,
            schema:      Blinky::Constants::SCHEMAS[key]
          }
        end

        def formalize(key, file_name)
          ctx = formalize_context(key, file_name)
          ::JFormalize::Engine.call(ctx)
        end

        def validate_and_formalize(key, file_name)
          result = formalize(key, file_name)
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
