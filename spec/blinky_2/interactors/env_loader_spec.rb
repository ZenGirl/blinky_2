require 'spec/spec_helper'

require 'blinky_2/interactors/env_loader'

# rubocop:disable Metrics/BlockLength, Metrics/LineLength, Layout/SpaceInsideBlockBraces
# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
describe Blinky2::EnvLoader do

  # Test private methods
  describe 'Private methods' do
    let(:not_present_message) {'The TEST_VAR environment variable is not present'}
    let(:not_usable_message) {'The TEST_VAR environment variable is not a usable string'}
    let(:not_readable_message) {'The TEST_VAR environment variable does not name a readable file'}

    describe '#fail_with_msg' do
      it 'fails with correct message for not_present' do
        expect {subject.send(:fail_with_msg, 'TEST_VAR', :not_present)}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq(not_present_message)
      end
      it 'fails with correct message for not_usable' do
        expect {subject.send(:fail_with_msg, 'TEST_VAR', :not_usable)}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq(not_usable_message)
      end
      it 'fails with correct message for not_readable' do
        expect {subject.send(:fail_with_msg, 'TEST_VAR', :not_readable)}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq(not_readable_message)
      end
    end
    describe '#variable_must_exist' do
      it 'fails with correct message when variable does not exist' do
        expect {subject.send(:variable_must_exist, 'TEST_VAR', nil)}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq(not_present_message)
      end
      it 'succeeds if variable does exist' do
        expect {subject.send(:variable_must_exist, 'TEST_VAR', 'TEST_VARIABLE')}.not_to raise_error(Interactor::Failure)
        expect(subject.context.error).to be_nil
      end
    end
    describe '#filename_must_be_usable' do
      it 'fails with correct message when variable is an empty string' do
        expect {subject.send(:filename_must_be_usable, 'TEST_VAR', '')}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq(not_usable_message)
      end
      it 'succeeds if variable is a nob-empty string' do
        expect {subject.send(:filename_must_be_usable, 'TEST_VAR', 'TEST_VAR')}.not_to raise_error(Interactor::Failure)
        expect(subject.context.error).to be_nil
      end
    end
    describe '#file_must_be_readable' do
      it 'fails with correct message when file is not found' do
        expect {subject.send(:file_must_be_readable, 'TEST_VAR', './non-existent-file')}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq('The TEST_VAR environment variable does not name a readable file')
      end
      it 'fails with correct message when file is not a file' do
        expect {subject.send(:file_must_be_readable, 'TEST_VAR', './spec/support/dummy_folder')}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq(not_readable_message)
      end
      context 'With chmod-ing' do
        before do
          File.chmod(0222, './spec/support/unreadable_file')
        end
        after do
          File.chmod(0444, './spec/support/unreadable_file')
        end
        it 'fails with correct message when file is not readable' do
          expect {subject.send(:file_must_be_readable, 'TEST_VAR', './spec/support/unreadable_file')}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq(not_readable_message)
        end
      end
    end
  end

  # Validate if required environment variables exist
  describe 'Test environment variables' do
    let(:readable_file) {'./spec/support/readable_file'}
    let(:unreadable_file) {'./spec/support/unreadable_file'}
    describe 'Failures' do
      context 'Not in environment' do
        it 'fails if BLINKY2_TICKETS is not in environment' do
          ENV['BLINKY2_ORGANISATIONS'] = readable_file
          ENV['BLINKY2_TICKETS']       = nil
          ENV['BLINKY2_USERS']         = readable_file
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_TICKETS environment variable is not present')
        end
        it 'fails if BLINKY2_USERS is not in environment' do
          ENV['BLINKY2_ORGANISATIONS'] = readable_file
          ENV['BLINKY2_TICKETS']       = readable_file
          ENV['BLINKY2_USERS']         = nil
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_USERS environment variable is not present')
        end
        it 'fails if BLINKY2_ORGANISATIONS is not in environment' do
          ENV['BLINKY2_ORGANISATIONS'] = nil
          ENV['BLINKY2_TICKETS']       = readable_file
          ENV['BLINKY2_USERS']         = readable_file
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_ORGANISATIONS environment variable is not present')
        end
      end
      context 'Must be usable filename' do
        it 'fails if BLINKY2_TICKETS is not usable' do
          ENV['BLINKY2_ORGANISATIONS'] = readable_file
          ENV['BLINKY2_TICKETS']       = ''
          ENV['BLINKY2_USERS']         = readable_file
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_TICKETS environment variable is not a usable string')
        end
        it 'fails if BLINKY2_USERS is not usable' do
          ENV['BLINKY2_ORGANISATIONS'] = readable_file
          ENV['BLINKY2_TICKETS']       = readable_file
          ENV['BLINKY2_USERS']         = ''
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_USERS environment variable is not a usable string')
        end
        it 'fails if BLINKY2_ORGANISATIONS usable' do
          ENV['BLINKY2_ORGANISATIONS'] = ''
          ENV['BLINKY2_TICKETS']       = readable_file
          ENV['BLINKY2_USERS']         = readable_file
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_ORGANISATIONS environment variable is not a usable string')
        end
      end
      context 'Must be a real readable file' do
        before do
          File.chmod(0222, unreadable_file)
        end
        after do
          File.chmod(0444, unreadable_file)
        end
        it 'fails if BLINKY2_TICKETS does not name a readable file' do
          ENV['BLINKY2_ORGANISATIONS'] = readable_file
          ENV['BLINKY2_TICKETS']       = unreadable_file
          ENV['BLINKY2_USERS']         = readable_file
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_TICKETS environment variable does not name a readable file')
        end
        it 'fails if BLINKY2_USERS does not name a readable file' do
          ENV['BLINKY2_ORGANISATIONS'] = readable_file
          ENV['BLINKY2_TICKETS']       = readable_file
          ENV['BLINKY2_USERS']         = unreadable_file
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_USERS environment variable does not name a readable file')
        end
        it 'fails if BLINKY2_ORGANISATIONS does not name a readable file' do
          ENV['BLINKY2_ORGANISATIONS'] = unreadable_file
          ENV['BLINKY2_TICKETS']       = readable_file
          ENV['BLINKY2_USERS']         = readable_file
          expect {subject.call}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY2_ORGANISATIONS environment variable does not name a readable file')
        end
      end
    end
    describe 'Successes' do
      it 'succeeds if env vars are in environment, usable and readable' do
        ENV['BLINKY2_ORGANISATIONS'] = readable_file
        ENV['BLINKY2_TICKETS']       = readable_file
        ENV['BLINKY2_USERS']         = readable_file
        expect {subject.call}.not_to raise_error(Interactor::Failure)
        expect(subject.context.error).to be_nil
        expect(subject.context.organisations_file).to eq(readable_file)
        expect(subject.context.tickets_file).to eq(readable_file)
        expect(subject.context.users_file).to eq(readable_file)
      end
    end
  end

end
