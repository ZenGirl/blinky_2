# rubocop:disable Style/FrozenStringLiteralComment
# Disabled, because we have to fiddle with strings that *may* be frozen

require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/utils'
require 'blinky/pre_flight/interactors/valid_json_files'

# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
# rubocop:disable Layout/SpaceInsideBlockBraces
describe Blinky::PreFlight::Interactors::ValidJsonFiles do
  describe 'private methods' do
    let(:file_name) {'[irrelevant file name]'}
    context '#must_not_be_too_big' do
      context 'should fail if' do
        it 'file_size > max size' do
          max_size = Blinky::Constants::MAX_FILE_SIZE
          allow(File).to receive(:size).with(file_name).and_return(max_size + 1)
          expect {subject.send(:must_not_be_too_big, file_name)}.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.error).to eq "Error: #{file_name} file is too big"
        end
      end
      context 'should succeed if' do
        it 'file size < max size' do
          max_size  = Blinky::Constants::MAX_FILE_SIZE
          allow(File).to receive(:size).with(file_name).and_return(max_size)
          expect {subject.send(:must_not_be_too_big, file_name)}.not_to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be true
        end
      end
    end

    context '#load_file' do
      context 'should fail' do

        def raises_error(file_name, msg)
          expect {subject.send(:load_file, file_name)}.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.error).to eq msg
        end

        it 'if IOError raised' do
          allow(IO).to receive(:read).and_raise(IOError, 'Dummy error')
          raises_error(file_name, 'Error: [irrelevant file name] file caused an exception: Dummy error')
        end

        it 'if StandardError raised' do
          allow(IO).to receive(:read).and_raise(StandardError, 'Dummy error')
          raises_error(file_name, 'Error: [irrelevant file name] file caused an exception: Dummy error')
        end

        it 'if returned string is empty (no newlines)' do
          allow(IO).to receive(:read).and_return('      ')
          raises_error(file_name, 'Error: [irrelevant file name] is not valid json')
        end

        it 'if returned string is empty (with newlines)' do
          allow(IO).to receive(:read).and_return("\n\n\n\n\n")
          raises_error(file_name, 'Error: [irrelevant file name] is not valid json')
        end

        it 'if returned string has non UTF-8 chars in it' do
          allow(IO).to receive(:read).and_return('hellÔ!'.encode('ISO-8859-1'))
          raises_error(file_name, 'Error: [irrelevant file name] has non UTF-8 chars')
        end
      end
      context 'should succeed' do
        it 'if string is non blank and has only UTF-8 chars in it' do
          allow(IO).to receive(:read).and_return('not json but valid UTF-8 string')
          expect {subject.send(:load_file, file_name)}.not_to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be true
        end
      end
    end

    context '#must_match_regex' do
      context 'should fail' do
        it 'if file contents are not valid json' do
          json = 'gumby is not valid'
          expect {subject.send(:must_match_regex, file_name, json)}.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.error).to eq 'Error: [irrelevant file name] is not valid json'
        end
      end

      context 'should succeed' do
        it 'if file contents are valid json' do
          json = '[{"a":"aaa","b":"bbb"},{"c":"ccc"}]'
          expect {subject.send(:must_match_regex, file_name, json)}.not_to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be true
        end
      end
    end
  end
end
# rubocop:enable Layout/SpaceInsideBlockBraces
