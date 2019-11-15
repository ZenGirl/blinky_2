# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/pre_flight/interactors/valid_env_variables'
require 'blinky/pre_flight/interactors/valid_readable_files'
require 'blinky/pre_flight/interactors/valid_json_files'

require 'blinky/pre_flight/organizers/train'

# rubocop:disable Layout/SpaceInsideBlockBraces
describe Blinky::PreFlight::Organizers::Train do
  context 'Raises failure if' do
    def raises_error(env_var)
      expect {subject.call}.to raise_error(Interactor::Failure)
      expect(subject.context.success?).to be false
      expect(subject.context.error).to eq formatted_message(env_var)
    end

    context 'in ValidEnvVariables' do
      def formatted_message(env_var)
        "The #{env_var} environment variable is not present"
      end

      it 'if TICKETS variable invalid' do
        raises_error('TICKETS')
      end
      it 'if USERS variable invalid' do
        ENV['TICKETS'] = 'irrelevant'
        raises_error('USERS')
      end
      it 'if ORGANISATIONS variable invalid' do
        ENV['TICKETS'] = 'irrelevant'
        ENV['USERS']   = 'irrelevant'
        raises_error('ORGANISATIONS')
      end
    end
    context 'in ValidReadableFiles' do
      let(:unreadable_file) {'spec/support/unreadable_file'}
      before do
        File.chmod(0222, unreadable_file)
      end
      after do
        File.chmod(0644, unreadable_file)
      end
      before :each do
        ENV['TICKETS']       = 'spec/support/readable_file'
        ENV['USERS']         = 'spec/support/readable_file'
        ENV['ORGANISATIONS'] = 'spec/support/readable_file'
      end
      context 'File does not exist' do
        def formatted_message(env_var)
          "The #{env_var} environment variable file spec/support/irrelevant does not name an existing file"
        end

        it 'if context.tickets_file not found' do
          ENV['TICKETS'] = 'spec/support/irrelevant'
          raises_error('TICKETS')
        end
        it 'if context.users_file not found' do
          ENV['USERS'] = 'spec/support/irrelevant'
          raises_error('USERS')
        end
        it 'if context.organisations_file not found' do
          ENV['ORGANISATIONS'] = 'spec/support/irrelevant'
          raises_error('ORGANISATIONS')
        end
      end
      context 'File is not a file' do
        def formatted_message(env_var)
          "The #{env_var} environment variable file spec/support/dummy_folder does not name a readable file"
        end

        it 'if context.tickets_file not a file' do
          ENV['TICKETS'] = 'spec/support/dummy_folder'
          raises_error('TICKETS')
        end
        it 'if context.users_file not a file' do
          ENV['USERS'] = 'spec/support/dummy_folder'
          raises_error('USERS')
        end
        it 'if context.organisations_file not a file' do
          ENV['ORGANISATIONS'] = 'spec/support/dummy_folder'
          raises_error('ORGANISATIONS')
        end
      end
      context 'File is not readable' do
        def formatted_message(env_var)
          "The #{env_var} environment variable file spec/support/unreadable_file does not name a readable file"
        end

        it 'if context.tickets_file not readable' do
          ENV['TICKETS'] = 'spec/support/unreadable_file'
          raises_error('TICKETS')
        end
        it 'if context.users_file not readable' do
          ENV['USERS'] = 'spec/support/unreadable_file'
          raises_error('USERS')
        end
        it 'if context.organisations_file not readable' do
          ENV['ORGANISATIONS'] = 'spec/support/unreadable_file'
          raises_error('ORGANISATIONS')
        end
      end
    end
    context 'in ValidJsonFiles' do
      let(:good_json_file) {'spec/support/good_file.json'}
      let(:bad_json_file) {'spec/support/bad_file.json'}
      before :each do
        ENV['TICKETS']       = good_json_file
        ENV['USERS']         = good_json_file
        ENV['ORGANISATIONS'] = good_json_file
      end

      def formatted_message(env_var)
        "The file #{ENV[env_var]} is not valid json"
      end

      it 'if context.tickets_file is not valid json' do
        ENV['TICKETS'] = bad_json_file
        raises_error('TICKETS')
      end
      it 'if context.users_file not found' do
        ENV['USERS'] = bad_json_file
        raises_error('USERS')
      end
      it 'if context.organisations_file not found' do
        ENV['ORGANISATIONS'] = bad_json_file
        raises_error('ORGANISATIONS')
      end
    end
  end
  context 'Succeeds and does not raise failure if' do
    let(:good_json_file) {'spec/support/good_file.json'}
    before :each do
      ENV['TICKETS']       = good_json_file
      ENV['USERS']         = good_json_file
      ENV['ORGANISATIONS'] = good_json_file
    end

    it 'all files are ok' do
      expect {subject.call}.not_to raise_error(Interactor::Failure)
      expect(subject.context.success?).to be true
    end
  end
end
# rubocop:enable Layout/SpaceInsideBlockBraces
