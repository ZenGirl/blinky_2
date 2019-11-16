# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/utils'

require 'blinky/pre_flight/interactors/valid_env_variables'
require 'blinky/pre_flight/interactors/valid_readable_files'
require 'blinky/pre_flight/interactors/valid_json_files'

require 'blinky/pre_flight/organizers/train'

# rubocop:disable Layout/SpaceInsideBlockBraces, Metrics/LineLength
describe Blinky::PreFlight::Organizers::Train do
  context 'Raises failure if' do
    def raises_error(msg)
      expect {subject.call}.to raise_error(Interactor::Failure)
      expect(subject.context.success?).to be false
      expect(subject.context.error).to eq msg
    end

    context 'in ValidEnvVariables' do
      before :each do
        ENV['TICKETS']       = nil
        ENV['USERS']         = nil
        ENV['ORGANIZATIONS'] = nil
      end
      it 'if TICKETS variable not present' do
        raises_error('Error: TICKETS environment variable is not present')
      end
      it 'if USERS variable not present' do
        ENV['TICKETS'] = 'irrelevant'
        raises_error('Error: USERS environment variable is not present')
      end
      it 'if ORGANIZATIONS variable not present' do
        ENV['TICKETS'] = 'irrelevant'
        ENV['USERS']   = 'irrelevant'
        raises_error('Error: ORGANIZATIONS environment variable is not present')
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
        ENV['ORGANIZATIONS'] = 'spec/support/readable_file'
      end
      context 'File does not exist' do
        it 'if context.tickets_file not found' do
          ENV['TICKETS'] = 'spec/support/irrelevant'
          raises_error('Error: TICKETS environment variable spec/support/irrelevant does not name an existing file')
        end
        it 'if context.users_file not found' do
          ENV['USERS'] = 'spec/support/irrelevant'
          raises_error('Error: USERS environment variable spec/support/irrelevant does not name an existing file')
        end
        it 'if context.organizations_file not found' do
          ENV['ORGANIZATIONS'] = 'spec/support/irrelevant'
          raises_error('Error: ORGANIZATIONS environment variable spec/support/irrelevant does not name an existing file')
        end
      end
      context 'File is not a file' do
        it 'if context.tickets_file not a file' do
          ENV['TICKETS'] = 'spec/support/dummy_folder'
          raises_error('Error: TICKETS environment variable spec/support/dummy_folder does not name a readable file')
        end
        it 'if context.users_file not a file' do
          ENV['USERS'] = 'spec/support/dummy_folder'
          raises_error('Error: USERS environment variable spec/support/dummy_folder does not name a readable file')
        end
        it 'if context.organizations_file not a file' do
          ENV['ORGANIZATIONS'] = 'spec/support/dummy_folder'
          raises_error('Error: ORGANIZATIONS environment variable spec/support/dummy_folder does not name a readable file')
        end
      end
      context 'File is not readable' do
        it 'if context.tickets_file not readable' do
          ENV['TICKETS'] = 'spec/support/unreadable_file'
          raises_error('Error: TICKETS environment variable spec/support/unreadable_file does not name a readable file')
        end
        it 'if context.users_file not readable' do
          ENV['USERS'] = 'spec/support/unreadable_file'
          raises_error('Error: USERS environment variable spec/support/unreadable_file does not name a readable file')
        end
        it 'if context.organizations_file not readable' do
          ENV['ORGANIZATIONS'] = 'spec/support/unreadable_file'
          raises_error('Error: ORGANIZATIONS environment variable spec/support/unreadable_file does not name a readable file')
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

      it 'if context.tickets_file is not valid json' do
        ENV['TICKETS'] = bad_json_file
        raises_error('Error: spec/support/bad_file.json is not valid json')
      end
      it 'if context.users_file not found' do
        ENV['USERS'] = bad_json_file
        raises_error('Error: spec/support/bad_file.json is not valid json')
      end
      it 'if context.organizations_file not found' do
        ENV['ORGANIZATIONS'] = bad_json_file
        raises_error('Error: spec/support/bad_file.json is not valid json')
      end
    end
  end
  context 'Succeeds and does not raise failure if' do
    let(:good_json_file) {'spec/support/good_file.json'}
    before :each do
      ENV['TICKETS']       = good_json_file
      ENV['USERS']         = good_json_file
      ENV['ORGANIZATIONS'] = good_json_file
    end

    it 'all files are ok' do
      expect {subject.call}.not_to raise_error(Interactor::Failure)
      expect(subject.context.success?).to be true
    end
  end
end
# rubocop:enable Layout/SpaceInsideBlockBraces, Metrics/LineLength
