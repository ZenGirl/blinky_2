require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/interactors/pre_flight/valid_env_variables'

# rubocop:disable Metrics/BlockLength, Metrics/LineLength, Layout/SpaceInsideBlockBraces
# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
describe Blinky::Interactors::ValidEnvVariables do
  let(:tickets_name) {'TICKETS'}
  let(:users_name) {'USERS'}
  let(:organisations_name) {'ORGANISATIONS'}
  describe 'Private Methods' do
    describe 'Raises interactor failure for' do
      let(:is_not_present) {'is not present'}
      let(:is_blank) {'is blank'}

      def formatted_message(env_var, suffix)
        "The #{env_var} environment variable #{suffix}"
      end

      def raises_interactor_failure(env_var, env_value, msg_suffix)
        ENV[env_var] = env_value
        expect {subject.send(:validate_env_var, env_var)}.to raise_error(Interactor::Failure)
        expect(subject.context.success?).to be false
        expect(subject.context.error).to eq formatted_message(env_var, msg_suffix)
      end

      context 'each env var TICKETS, USERS and ORGANISATIONS' do
        context 'if value is nil then context.error' do
          it {raises_interactor_failure(tickets_name, nil, is_not_present)}
          it {raises_interactor_failure(users_name, nil, is_not_present)}
          it {raises_interactor_failure(organisations_name, nil, is_not_present)}
        end
        context 'or if value is empty string then context.error' do
          it {raises_interactor_failure(tickets_name, '', is_blank)}
          it {raises_interactor_failure(users_name, '', is_blank)}
          it {raises_interactor_failure(organisations_name, '', is_blank)}
        end
        context 'or if value is blank after stripping then context.error' do
          it {raises_interactor_failure(tickets_name, '     ', is_blank)}
          it {raises_interactor_failure(users_name, '     ', is_blank)}
          it {raises_interactor_failure(organisations_name, '     ', is_blank)}
        end
      end
    end

    describe 'Does not raise interactor failure for' do
      def no_interactor_failure(env_var, env_value)
        ENV[env_var] = env_value
        expect {subject.send(:validate_env_var, env_var)}.to_not raise_error(Interactor::Failure)
        expect(subject.context.error).to be nil
        expect(subject.context.success?).to be true
      end

      context 'each env var TICKETS, USERS and ORGANISATIONS' do
        context 'if TICKETS is present and not blank then success' do
          it {no_interactor_failure(tickets_name, 'Dummy')}
        end
        context 'if USERS is present and not blank and success' do
          it {no_interactor_failure(users_name, 'Dummy')}
        end
        context 'if ORGANISATIONS is present and not blank and success' do
          it {no_interactor_failure(organisations_name, 'Dummy')}
        end
      end
    end
  end

  describe '#call' do
    context 'when all env vars are present and valid then success' do
      before do
        ENV[tickets_name]       = 'Dummy Tickets'
        ENV[users_name]         = 'Dummy Users'
        ENV[organisations_name] = 'Dummy Organisations'
        subject.call
      end

      it {expect(subject.context.success?).to be true}
      context 'and tickets_file' do
        it {expect(subject.context.tickets_file).to eq 'Dummy Tickets'}
      end
      context 'and users_file' do
        it {expect(subject.context.users_file).to eq 'Dummy Users'}
      end
      context 'and organisations_file' do
        it {expect(subject.context.organisations_file).to eq 'Dummy Organisations'}
      end
    end

    context 'and if any env value is not usable then' do
      before do
        ENV[tickets_name]       = nil
        ENV[users_name]         = nil
        ENV[organisations_name] = nil
      end

      it 'raises error and fails' do
        expect {subject.call}.to raise_error(Interactor::Failure)
        expect(subject.context.success?).to be false
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/LineLength, Layout/SpaceInsideBlockBraces
