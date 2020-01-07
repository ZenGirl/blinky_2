# rubocop:disable Style/FrozenStringLiteralComment
# Disabled, because we have to fiddle with strings that *may* be frozen

require 'spec_helper'

require 'interactor'

require 'j_formalize'

require_relative '../../../../blinky/constants'
require_relative '../../../../blinky/utils'

require_relative '../../../../blinky/pre_flight/interactors/valid_json_files'

describe Blinky::PreFlight::Interactors::ValidJsonFiles do
  describe 'private methods' do
    let(:file_name) { '[irrelevant file name]' }

    context '#load_file' do
      context 'should fail' do
        def load_raises_error(key, file_name, msg)
          expect { subject.send(:load_file, key, file_name) }.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.message).to eq msg
        end

        it 'if IOError raised' do
          allow(IO).to receive(:read).and_raise(IOError, 'Dummy error')
          load_raises_error(:tickets, file_name, 'tickets [irrelevant file name] caused an error Dummy error')
        end

        it 'if StandardError raised' do
          allow(IO).to receive(:read).and_raise(StandardError, 'Dummy error')
          load_raises_error(:tickets, file_name, 'tickets [irrelevant file name] caused an error Dummy error')
        end
      end
      context 'should succeed' do
        it 'if string is non blank and has only UTF-8 chars in it' do
          allow(IO).to receive(:read).and_return('not json but valid UTF-8 string')
          expect { subject.send(:load_file, file_name) }.not_to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be true
        end
      end
    end
    context '#validate_and_formalize' do
      context 'should fail' do
        def validate_raises_error(key, file_name, msg)
          objects = {}
          expect { subject.send(:validate_and_formalize, key, file_name) }.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.message).to eq msg
        end

        it 'if returned string is empty (no newlines)' do
          allow(IO).to receive(:read).and_return('      ')
          validate_raises_error(:tickets, file_name, 'tickets [irrelevant file name] json_string must not be empty')
        end

        it 'if returned string is empty (with newlines)' do
          allow(IO).to receive(:read).and_return("  \n  \n\n")
          validate_raises_error(:tickets, file_name, 'tickets [irrelevant file name] json_string must not be empty')
        end

        it 'if returned string has non UTF-8 chars in it' do
          allow(IO).to receive(:read).and_return('hellÔ!'.encode('ISO-8859-1'))
          validate_raises_error(:tickets, file_name, 'tickets [irrelevant file name] json_string has non UTF-8 characters')
        end
      end
      context 'should succeed' do
        it 'if string is non blank and has only UTF-8 chars in it' do
          allow(IO).to receive(:read).and_return('not json but valid UTF-8 string')
          expect { subject.send(:validate_and_formalize, file_name) }.not_to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be true
        end
      end
    end
  end

  describe '#call' do
    context 'when all env vars are present and valid then success' do
      before do
        subject.context.tickets_file       = 'spec/support/tickets_test.json'
        subject.context.users_file         = 'spec/support/users_test.json'
        subject.context.organizations_file = 'spec/support/organizations_test.json'
        subject.call
      end

      it { expect(subject.context.success?).to be true }
      context 'and tickets_file' do
        it {expect(subject.context.tickets).to_not be nil}
        it {expect(subject.context.tickets.is_a?(Array)).to be true}
        it {expect(subject.context.tickets.size).to eq 2}
        it {expect(subject.context.tickets[0][:_id]).to eq '436bf9b0-1147-4c0a-8439-6f79833bff5b'}
        it {expect(subject.context.tickets[1][:_id]).to eq '1a227508-9f39-427c-8f57-1b72f3fab87c'}
      end
      context 'and users_file' do
        it {expect(subject.context.users).to_not be nil}
        it {expect(subject.context.users.is_a?(Array)).to be true}
        it {expect(subject.context.users.size).to eq 2}
        it {expect(subject.context.users[0][:_id]).to eq 1}
        it {expect(subject.context.users[1][:_id]).to eq 2}
      end
      context 'and organizations_file' do
        it {expect(subject.context.organizations).to_not be nil}
        it {expect(subject.context.organizations.is_a?(Array)).to be true}
        it {expect(subject.context.organizations.size).to eq 2}
        it {expect(subject.context.organizations[0][:_id]).to eq 101}
        it {expect(subject.context.organizations[1][:_id]).to eq 102}
      end
    end
  end
end
