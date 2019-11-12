module Blinky

  module Interactors

    # Ensures that all the file names provide exist and are readable.
    class ValidReadableFiles
      include Interactor

      def call
        [
          ['BLINKY_TICKETS', context.tickets_file]
        ].each do |arr|
          ap arr
          name_must_be_readable arr[0], arr[1]
        end
      end

      private

      def name_must_be_readable(env_var, file_name)
        must_exist(env_var, file_name)
        must_be_a_file(env_var, file_name)
        must_be_readable(env_var, file_name)
      end

      def must_be_readable(env_var, file_name)
        fail_with_msg env_var, file_name, :not_readable unless File.readable? file_name
      end

      def must_be_a_file(env_var, file_name)
        fail_with_msg env_var, file_name, :not_readable unless File.file? file_name
      end

      def must_exist(env_var, file_name)
        fail_with_msg env_var, file_name, :not_readable unless File.exist? file_name
      end

      def fail_with_msg(env_var, file_name, msg)
        context.error = "The #{env_var} file #{file_name} #{Blinky::Constants::MESSAGES[msg]}"
        context.fail!
      end

    end

  end

end
