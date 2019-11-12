require 'spec/spec_helper'

require 'interactor'
require 'blinky/constants'
require 'blinky/interactors/valid_readable_files'

# rubocop:disable Metrics/BlockLength, Metrics/LineLength, Layout/SpaceInsideBlockBraces
# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
describe Blinky::Interactors::ValidReadableFiles do

  describe 'private methods' do

    describe '#must_be_readable' do
      context 'BLINKY_TICKETS' do
        it 'fails with correct message if not readable' do
          expect {subject.send(:must_be_readable, 'BLINKY_TICKETS', 'spec/not_an_existing_file')}.to raise_error(Interactor::Failure)
          expect(subject.context.error).to eq('The BLINKY_TICKETS file spec/not_an_existing_file does not name a readable file')
        end
      end
    end

    describe 'BLINKY_TICKETS' do
      it 'fails with correct message when file is not readable' do
        expect {subject.send(:file_must_be_readable, 'BLINKY_TICKETS', 'spec/not_an_existing_file')}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq('The BLINKY_TICKETS file spec/not_an_existing_file does not name a readable file')
      end
      it 'succeeds with correct message when file is readable' do
        expect {subject.send(:file_must_be_readable, 'BLINKY_TICKETS', 'spec/support/readable_file')}.to_not raise_error(Interactor::Failure)
        expect(subject.context.error).to be nil
      end
    end

    describe 'BLINKY_USERS' do
      it 'fails with correct message when file is not readable' do
        expect {subject.send(:file_must_be_readable, 'BLINKY_USERS', 'spec/not_an_existing_file')}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq('The BLINKY_USERS file spec/not_an_existing_file does not name a readable file')
      end
      it 'succeeds with correct message when file is readable' do
        expect {subject.send(:file_must_be_readable, 'BLINKY_USERS', 'spec/support/readable_file')}.to_not raise_error(Interactor::Failure)
        expect(subject.context.error).to be nil
      end
    end

    describe 'BLINKY_ORGANISATIONS' do
      it 'fails with correct message when file is not readable' do
        expect {subject.send(:file_must_be_readable, 'BLINKY_ORGANISATIONS', 'spec/not_an_existing_file')}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq('The BLINKY_ORGANISATIONS file spec/not_an_existing_file does not name a readable file')
      end
      it 'succeeds with correct message when file is readable' do
        expect {subject.send(:file_must_be_readable, 'BLINKY_ORGANISATIONS', 'spec/support/readable_file')}.to_not raise_error(Interactor::Failure)
        expect(subject.context.error).to be nil
      end
    end

  end

end
