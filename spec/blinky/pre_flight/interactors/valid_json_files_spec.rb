# rubocop:disable Style/FrozenStringLiteralComment

require 'spec/spec_helper'

require 'blinky/pre_flight/interactors/valid_json_files'

# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
# rubocop:disable Layout/SpaceInsideBlockBraces
describe Blinky::PreFlight::Interactors::ValidJsonFiles do
  describe 'private methods' do
    def error_message(sym)
      Blinky::Constants::MESSAGES[sym]
    end

    def formatted_message(file_name, sym, exception_message)
      "Reading the #{file_name} #{error_message(sym)}#{exception_message}"
    end

    context '#must_not_be_too_big' do
      context 'should fail if' do
        file_name = 'spec/support/not_a_file'
        it 'file_size > max size' do
          max_size = Blinky::Constants::MAX_FILE_SIZE
          allow(File).to receive(:size).with(file_name).and_return(max_size + 1)
          expect {subject.send(:must_not_be_too_big, file_name)}.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.error).to eq "The #{file_name} should be less than #{max_size}"
        end
      end
      context 'should succeed if' do
        it 'file size < max size' do
          file_name = 'spec/support/under_max_size'
          max_size  = Blinky::Constants::MAX_FILE_SIZE
          allow(File).to receive(:size).with(file_name).and_return(max_size)
          expect {subject.send(:must_not_be_too_big, file_name)}.not_to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be true
        end
      end
    end

    context '#load_file' do
      context 'should fail' do
        let(:file_name) {'[irrelevant file name]'}

        def raises_error(file_name, msg)
          expect {subject.send(:load_file, file_name)}.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.error).to eq formatted_message(file_name, :file_error, msg)
        end

        it 'if IOError raised' do
          allow(IO).to receive(:read).and_raise(IOError, 'Dummy error')
          raises_error(file_name, 'Dummy error')
        end

        it 'if StandardError raised' do
          allow(IO).to receive(:read).and_raise(StandardError, 'Dummy error')
          raises_error(file_name, 'Dummy error')
        end

        it 'if returned string is empty (no newlines)' do
          allow(IO).to receive(:read).and_return('      ')
          raises_error(file_name, error_message(:invalid_json))
        end

        it 'if returned string is empty (with newlines)' do
          allow(IO).to receive(:read).and_return("\n\n\n\n\n")
          raises_error(file_name, error_message(:invalid_json))
        end

        it 'if returned string has non UTF-8 chars in it' do
          allow(IO).to receive(:read).and_return('hellÔ!'.encode('ISO-8859-1'))
          raises_error(file_name, error_message(:non_utf8))
        end
      end
      context 'should succeed' do
        let(:file_name) {'[irrelevant file name]'}

        it 'if string is non blank and has only UTF-8 chars in it' do
          allow(IO).to receive(:read).and_return('not json but valid UTF-8 string')
          expect {subject.send(:load_file, file_name)}.not_to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be true
        end
      end
    end

    context '#must_match_regex' do
      let(:file_name) {'[irrelevant file name]'}

      context 'should fail' do
        it 'if file contents are not valid json' do
          json = 'gumby is not valid'
          expect {subject.send(:must_match_regex, file_name, json)}.to raise_error(Interactor::Failure)
          expect(subject.context.success?).to be false
          expect(subject.context.error).to eq "The file #{file_name} is not valid json"
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
