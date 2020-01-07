# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../blinky/constants'
require_relative '../../../../blinky/utils'

require_relative '../../../../blinky/pre_flight/interactors/valid_env_variables'
require_relative '../../../../blinky/pre_flight/interactors/valid_readable_files'
require_relative '../../../../blinky/pre_flight/interactors/valid_json_files'

require_relative '../../../../blinky/pre_flight/organizers/engine'

describe Blinky::PreFlight::Organizers::Engine do
  let(:unreadable_file) { 'spec/support/unreadable_file' }
  let(:readable_file) { 'spec/support/readable_file' }
  let(:irrelevant) { 'spec/support/irrelevant' }
  let(:dummy_folder) { 'spec/support/dummy_folder' }
  context 'Raises failure if' do
    def raises_error(msg)
      expect { subject.call }.to raise_error(Interactor::Failure)
      expect(subject.context.success?).to be false
      expect(subject.context.message).to eq msg
    end

    context 'in ValidEnvVariables' do
      before :each do
        ENV['TICKETS']       = nil
        ENV['USERS']         = nil
        ENV['ORGANIZATIONS'] = nil
      end
      it 'if TICKETS variable not present' do
        raises_error('TICKETS is not present')
      end
      it 'if USERS variable not present' do
        ENV['TICKETS'] = 'irrelevant'
        raises_error('USERS is not present')
      end
      it 'if ORGANIZATIONS variable not present' do
        ENV['TICKETS'] = 'irrelevant'
        ENV['USERS']   = 'irrelevant'
        raises_error('ORGANIZATIONS is not present')
      end
    end
    context 'in ValidReadableFiles' do
      before do
        File.chmod(0222, unreadable_file)
      end
      after do
        File.chmod(0644, unreadable_file)
      end
      before :each do
        ENV['TICKETS']       = readable_file
        ENV['USERS']         = readable_file
        ENV['ORGANIZATIONS'] = readable_file
      end
      context 'File does not exist' do
        it 'if context.tickets_file not found' do
          ENV['TICKETS'] = irrelevant
          raises_error('TICKETS spec/support/irrelevant does not name an existing file')
        end
        it 'if context.users_file not found' do
          ENV['USERS'] = irrelevant
          raises_error('USERS spec/support/irrelevant does not name an existing file')
        end
        it 'if context.organizations_file not found' do
          ENV['ORGANIZATIONS'] = irrelevant
          raises_error('ORGANIZATIONS spec/support/irrelevant does not name an existing file')
        end
      end
      context 'File is not a file' do
        it 'if context.tickets_file not a file' do
          ENV['TICKETS'] = dummy_folder
          raises_error('TICKETS spec/support/dummy_folder does not name a readable file')
        end
        it 'if context.users_file not a file' do
          ENV['USERS'] = dummy_folder
          raises_error('USERS spec/support/dummy_folder does not name a readable file')
        end
        it 'if context.organizations_file not a file' do
          ENV['ORGANIZATIONS'] = dummy_folder
          raises_error('ORGANIZATIONS spec/support/dummy_folder does not name a readable file')
        end
      end
      context 'File is not readable' do
        it 'if context.tickets_file not readable' do
          ENV['TICKETS'] = unreadable_file
          raises_error('TICKETS spec/support/unreadable_file does not name a readable file')
        end
        it 'if context.users_file not readable' do
          ENV['USERS'] = unreadable_file
          raises_error('USERS spec/support/unreadable_file does not name a readable file')
        end
        it 'if context.organizations_file not readable' do
          ENV['ORGANIZATIONS'] = unreadable_file
          raises_error('ORGANIZATIONS spec/support/unreadable_file does not name a readable file')
        end
      end
    end
    context 'in ValidJsonFiles' do
      let(:bad_json_file) { 'spec/support/bad_file.json' }
      before :each do
        ENV['TICKETS']       = 'spec/support/tickets_test.json'
        ENV['USERS']         = 'spec/support/users_test.json'
        ENV['ORGANIZATIONS'] = 'spec/support/organizations_test.json'
      end

      def raises_error(msg)
        expect { subject.call }.to raise_error(Interactor::Failure)
        expect(subject.context.success?).to be false
        expect(subject.context.message).to eq msg
      end

      it 'if context.tickets_file is not valid json' do
        ENV['TICKETS'] = bad_json_file
        raises_error('tickets spec/support/bad_file.json json_string does not match regex')
      end
      it 'if context.users_file is not valid json' do
        ENV['USERS'] = bad_json_file
        raises_error('users spec/support/bad_file.json json_string does not match regex')
      end
      it 'if context.organizations_file is not valid json' do
        ENV['ORGANIZATIONS'] = bad_json_file
        raises_error('organizations spec/support/bad_file.json json_string does not match regex')
      end
    end
  end
  context 'Succeeds and does not raise failure if' do
    before :all do
      ENV['TICKETS']       = 'spec/support/tickets_test.json'
      ENV['USERS']         = 'spec/support/users_test.json'
      ENV['ORGANIZATIONS'] = 'spec/support/organizations_test.json'
    end

    it 'all files are ok' do
      expect { subject.call }.not_to raise_error(Interactor::Failure)
      expect(subject.context.success?).to be true
    end
  end
  context 'Succeeds and returns correct formalized objects' do
    before do
      ENV['TICKETS']       = 'spec/support/tickets_test.json'
      ENV['USERS']         = 'spec/support/users_test.json'
      ENV['ORGANIZATIONS'] = 'spec/support/organizations_test.json'
      subject.call
    end

    it { expect(subject.context.success?).to be true }
    context 'and tickets_file' do
      it { expect(subject.context.tickets).to_not be nil }
      it { expect(subject.context.tickets.is_a?(Array)).to be true }
      it { expect(subject.context.tickets.size).to eq 2 }
      it { expect(subject.context.tickets[0][:_id]).to eq '436bf9b0-1147-4c0a-8439-6f79833bff5b' }
      it { expect(subject.context.tickets[1][:_id]).to eq '1a227508-9f39-427c-8f57-1b72f3fab87c' }
    end
    context 'and users_file' do
      it { expect(subject.context.users).to_not be nil }
      it { expect(subject.context.users.is_a?(Array)).to be true }
      it { expect(subject.context.users.size).to eq 2 }
      it { expect(subject.context.users[0][:_id]).to eq 1 }
      it { expect(subject.context.users[1][:_id]).to eq 2 }
    end
    context 'and organizations_file' do
      it { expect(subject.context.organizations).to_not be nil }
      it { expect(subject.context.organizations.is_a?(Array)).to be true }
      it { expect(subject.context.organizations.size).to eq 2 }
      it { expect(subject.context.organizations[0][:_id]).to eq 101 }
      it { expect(subject.context.organizations[1][:_id]).to eq 102 }
    end
  end
end
