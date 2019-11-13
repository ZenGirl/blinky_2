require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/interactors/valid_readable_files'

# rubocop:disable Metrics/BlockLength, Metrics/LineLength, Layout/SpaceInsideBlockBraces
# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
describe Blinky::Interactors::ValidReadableFiles do
  let(:does_not_name_existing_file) {'does not name an existing file'}
  let(:does_not_name_readable_file) {'does not name a readable file'}
  let(:not_an_existing_file) {'spec/support/not_an_existing_file'}
  let(:not_a_file) {'spec/support/dummy_folder'}
  let(:readable_file) {'spec/support/readable_file'}
  let(:unreadable_file) {'spec/support/unreadable_file'}
  let(:tickets_name) {'TICKETS'}
  let(:users_name) {'USERS'}
  let(:organisations_name) {'ORGANISATIONS'}

  def formatted_message(env_var, env_value, suffix)
    "The #{env_var} environment variable file #{env_value} #{suffix}"
  end

  def raises_interactor_failure(method, env_var, env_value, msg_suffix)
    expect {subject.send(method, env_var, env_value)}.to raise_error(Interactor::Failure)
    expect(subject.context.success?).to be false
    expect(subject.context.error).to eq formatted_message(env_var, env_value, msg_suffix)
  end

  describe 'Private methods' do
    describe 'Raises interactor failure for' do
      context 'each of context file names' do
        context 'if value does not exist then raises interactor failure and context.error' do
          it {raises_interactor_failure(:must_exist, tickets_name, not_an_existing_file, does_not_name_existing_file)}
          it {raises_interactor_failure(:must_exist, users_name, not_an_existing_file, does_not_name_existing_file)}
          it {raises_interactor_failure(:must_exist, organisations_name, not_an_existing_file, does_not_name_existing_file)}
        end
        context 'if value exists but is not a file then raises interactor failure and context.error' do
          it {raises_interactor_failure(:must_be_a_file, tickets_name, not_a_file, does_not_name_readable_file)}
          it {raises_interactor_failure(:must_be_a_file, users_name, not_a_file, does_not_name_readable_file)}
          it {raises_interactor_failure(:must_be_a_file, organisations_name, not_a_file, does_not_name_readable_file)}
        end
        context 'if value exists and is a file but is not readable then raises interactor failure and context.error' do
          before do
            File.chmod(0222, unreadable_file)
          end
          after do
            File.chmod(0644, unreadable_file)
          end
          it {raises_interactor_failure(:must_be_readable, tickets_name, unreadable_file, does_not_name_readable_file)}
          it {raises_interactor_failure(:must_be_readable, users_name, unreadable_file, does_not_name_readable_file)}
          it {raises_interactor_failure(:must_be_readable, organisations_name, unreadable_file, does_not_name_readable_file)}
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
      before do
        subject.context.tickets_file       = readable_file
        subject.context.users_file         = readable_file
        subject.context.organisations_file = readable_file
        subject.call
      end
      it {expect(subject.context.success?).to be true}
    end

    context 'when any file is not readable then ' do
      before do
        File.chmod(0222, unreadable_file)
        subject.context.tickets_file       = readable_file
        subject.context.users_file         = unreadable_file
        subject.context.organisations_file = readable_file
      end
      after do
        File.chmod(0644, unreadable_file)
      end

      it 'raises error and fails' do
        expect {subject.call}.to raise_error(Interactor::Failure)
        expect(subject.context.error).to eq 'The USERS environment variable file spec/support/unreadable_file does not name a readable file'
        expect(subject.context.success?).to be false
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/LineLength, Layout/SpaceInsideBlockBraces
