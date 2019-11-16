# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/utils'
require 'blinky/pre_flight/interactors/valid_readable_files'

# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
# rubocop:disable Metrics/LineLength, Layout/SpaceInsideBlockBraces
describe Blinky::PreFlight::Interactors::ValidReadableFiles do
  def raises_interactor_failure(method, env_var, env_value, suffix)
    ENV[env_var] = env_value
    expect {subject.send(method, env_var, env_value)}.to raise_error(Interactor::Failure)
    expect(subject.context.success?).to be false
    expect(subject.context.error).to eq "Error: #{env_var} environment variable #{env_value} #{suffix}"
  end

  def no_interactor_failure(env_var, env_value)
    ENV[env_var] = env_value
    expect {subject.send(:validate_env_var, env_var)}.to_not raise_error(Interactor::Failure)
    expect(subject.context.error).to be nil
    expect(subject.context.success?).to be true
  end

  let(:not_an_existing_file) {'spec/support/not_an_existing_file'}
  let(:not_a_file) {'spec/support/dummy_folder'}
  let(:readable_file) {'spec/support/readable_file'}
  let(:unreadable_file) {'spec/support/unreadable_file'}

  describe 'Private methods' do
    describe 'Raises interactor failure for' do
      context 'each of context file names' do
        context 'if value does not exist then raises interactor failure and context.error' do
          it {raises_interactor_failure(:must_exist, 'TICKETS', not_an_existing_file, 'does not name an existing file')}
          it {raises_interactor_failure(:must_exist, 'USERS', not_an_existing_file, 'does not name an existing file')}
          it {raises_interactor_failure(:must_exist, 'ORGANIZATIONS', not_an_existing_file, 'does not name an existing file')}
        end
        context 'if value exists but is not a file then raises interactor failure and context.error' do
          it {raises_interactor_failure(:must_be_a_file, 'TICKETS', not_a_file, 'does not name a readable file')}
          it {raises_interactor_failure(:must_be_a_file, 'USERS', not_a_file, 'does not name a readable file')}
          it {raises_interactor_failure(:must_be_a_file, 'ORGANIZATIONS', not_a_file, 'does not name a readable file')}
        end
        context 'if value exists and is a file but is not readable then raises interactor failure and context.error' do
          before do
            File.chmod(0222, unreadable_file)
          end
          after do
            File.chmod(0644, unreadable_file)
          end
          it {raises_interactor_failure(:must_be_readable, 'TICKETS', unreadable_file, 'does not name a readable file')}
          it {raises_interactor_failure(:must_be_readable, 'USERS', unreadable_file, 'does not name a readable file')}
          it {raises_interactor_failure(:must_be_readable, 'ORGANIZATIONS', unreadable_file, 'does not name a readable file')}
        end
      end
    end

    describe 'Does not raise interactor failure if' do
      def no_interactor_failure(env_value)
        expect {subject.send(:must_be_readable, env_value)}.to_not raise_error(Interactor::Failure)
      end

      context 'file exists and is readable then it' do
        it {no_interactor_failure('spec/support/readable_file')}
      end
    end
  end

  describe '#call' do
    context 'when all files are readable then success' do
      # Sigh. Just to get rid of those annoying twiddles for the context variables
      # noinspection RubyResolve
      before do
        subject.context.tickets_file       = readable_file
        subject.context.users_file         = readable_file
        subject.context.organizations_file = readable_file
        subject.call
      end
      it {expect(subject.context.success?).to be true}
    end

    context 'when any file is not readable then ' do
      # Sigh. Just to get rid of those annoying twiddles for the context variables
      # noinspection RubyResolve
      before do
        File.chmod(0222, unreadable_file)
        subject.context.tickets_file       = readable_file
        subject.context.users_file         = unreadable_file
        subject.context.organizations_file = readable_file
      end
      after do
        File.chmod(0644, unreadable_file)
      end

      it 'raises error and fails' do
        expect {subject.call}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq 'Error: USERS environment variable spec/support/unreadable_file does not name a readable file'
        expect(subject.context.success?).to be false
      end
    end
  end
end
# rubocop:enable Metrics/LineLength, Layout/SpaceInsideBlockBraces
