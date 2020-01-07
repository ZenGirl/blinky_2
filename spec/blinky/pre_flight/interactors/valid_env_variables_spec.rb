# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../blinky/constants'
require_relative '../../../../blinky/utils'

require_relative '../../../../blinky/pre_flight/interactors/valid_env_variables'

# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
# rubocop:disable Layout/SpaceInsideBlockBraces
describe Blinky::PreFlight::Interactors::ValidEnvVariables do
  def raises_interactor_failure(env_var, env_value, suffix)
    ENV[env_var] = env_value
    expect {subject.send(:validate_env_var, env_var)}.to raise_error(Interactor::Failure)
    expect(subject.context.success?).to be false
    expect(subject.context.message).to eq "#{env_var} #{suffix}"
  end

  def no_interactor_failure(env_var, env_value)
    ENV[env_var] = env_value
    expect {subject.send(:validate_env_var, env_var)}.to_not raise_error(Interactor::Failure)
    expect(subject.context.success?).to be true
  end

  describe 'Private Methods' do
    describe 'Raises interactor failure for' do
      context 'each env var TICKETS, USERS and ORGANIZATIONS' do
        context 'if value is nil then context.error message' do
          it {raises_interactor_failure('TICKETS', nil, 'is not present')}
          it {raises_interactor_failure('USERS', nil, 'is not present')}
          it {raises_interactor_failure('ORGANIZATIONS', nil, 'is not present')}
        end
        context 'or if value is empty string then context.error' do
          it {raises_interactor_failure('TICKETS', '', 'is blank')}
          it {raises_interactor_failure('USERS', '', 'is blank')}
          it {raises_interactor_failure('ORGANIZATIONS', '', 'is blank')}
        end
        context 'or if value is blank after stripping then context.error' do
          it {raises_interactor_failure('TICKETS', '     ', 'is blank')}
          it {raises_interactor_failure('USERS', '     ', 'is blank')}
          it {raises_interactor_failure('ORGANIZATIONS', '     ', 'is blank')}
        end
      end
    end

    describe 'Does not raise interactor failure for' do
      context 'each env var TICKETS, USERS and ORGANIZATIONS' do
        context 'if TICKETS is present and not blank then success' do
          it {no_interactor_failure('TICKETS', 'Dummy')}
        end
        context 'if USERS is present and not blank and success' do
          it {no_interactor_failure('USERS', 'Dummy')}
        end
        context 'if ORGANIZATIONS is present and not blank and success' do
          it {no_interactor_failure('ORGANIZATIONS', 'Dummy')}
        end
      end
    end
  end

  describe '#call' do
    context 'when all env vars are present and valid then success' do
      before do
        ENV['TICKETS']       = 'Dummy Tickets'
        ENV['USERS']         = 'Dummy Users'
        ENV['ORGANIZATIONS'] = 'Dummy Organizations'
        subject.call
      end

      it {expect(subject.context.success?).to be true}
      context 'and tickets_file' do
        it {expect(subject.context.tickets_file).to eq 'Dummy Tickets'}
      end
      context 'and users_file' do
        it {expect(subject.context.users_file).to eq 'Dummy Users'}
      end
      context 'and organizations_file' do
        it {expect(subject.context.organizations_file).to eq 'Dummy Organizations'}
      end
    end

    context 'and if any env value is not usable then' do
      before do
        ENV['TICKETS']       = nil
        ENV['USERS']         = nil
        ENV['ORGANIZATIONS'] = nil
      end

      it 'raises error and fails' do
        expect {subject.call}.to raise_error(Interactor::Failure)
        expect(subject.context.success?).to be false
      end
    end
  end
end
# rubocop:enable Layout/SpaceInsideBlockBraces
