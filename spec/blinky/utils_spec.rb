# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/utils'

class TestingUtils
  include Blinky::Utils
end

# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
# rubocop:disable Layout/SpaceInsideBlockBraces, Metrics/LineLength
describe TestingUtils do
  describe '#format_error' do
    context 'Environment Variables' do
      let(:errors) do
        # Disabled because it shows irritating message which provides no perceivable benefit
        # rubocop:disable Layout/AlignHash
        {
          tickets_not_present:                 'Error: TICKETS environment variable is not present',
          tickets_is_blank:                    'Error: TICKETS environment variable is blank',
          tickets_file_not_found:              'Error: TICKETS environment variable does not name an existing file',
          tickets_file_not_readable:           'Error: TICKETS environment variable does not name a readable file',
          tickets_file_caused_exception:       'Error: TICKETS environment variable file caused an exception: Dummy Exception',
          tickets_file_not_json:               'Error: TICKETS environment variable file [dummy_file] is not valid json',
          tickets_file_non_utf8:               'Error: TICKETS environment variable file [dummy_file] has non UTF-8 characters',
          users_not_present:                   'Error: USERS environment variable is not present',
          users_is_blank:                      'Error: USERS environment variable is blank',
          users_file_not_found:                'Error: USERS environment variable does not name an existing file',
          users_file_not_readable:             'Error: USERS environment variable does not name a readable file',
          users_file_caused_exception:         'Error: USERS environment variable file caused an exception: Dummy Exception',
          users_file_not_json:                 'Error: USERS environment variable file [dummy_file] is not valid json',
          users_file_non_utf8:                 'Error: USERS environment variable file [dummy_file] has non UTF-8 characters',
          organizations_not_present:           'Error: ORGANIZATIONS environment variable is not present',
          organizations_is_blank:              'Error: ORGANIZATIONS environment variable is blank',
          organizations_file_not_found:        'Error: ORGANIZATIONS environment variable does not name an existing file',
          organizations_file_not_readable:     'Error: ORGANIZATIONS environment variable does not name a readable file',
          organizations_file_caused_exception: 'Error: ORGANIZATIONS environment variable file caused an exception: Dummy Exception',
          organizations_file_not_json:         'Error: ORGANIZATIONS environment variable file [dummy_file] is not valid json',
          organizations_file_non_utf8:         'Error: ORGANIZATIONS environment variable file [dummy_file] has non UTF-8 characters'
        }
        # rubocop:enable Layout/AlignHash
      end

      context 'For each of TICKETS, USERS and ORGANIZATIONS' do
        context 'if not present then message' do
          it {expect(subject.format_error('TICKETS environment variable', :env_var_not_present, '', '')).to eq errors[:tickets_not_present]}
          it {expect(subject.format_error('USERS environment variable', :env_var_not_present, '', '')).to eq errors[:users_not_present]}
          it {expect(subject.format_error('ORGANIZATIONS environment variable', :env_var_not_present, '', '')).to eq errors[:organizations_not_present]}
        end
        context 'if blank then message' do
          it {expect(subject.format_error('TICKETS environment variable', :env_var_is_blank, '', '')).to eq errors[:tickets_is_blank]}
          it {expect(subject.format_error('USERS environment variable', :env_var_is_blank, '', '')).to eq errors[:users_is_blank]}
          it {expect(subject.format_error('ORGANIZATIONS environment variable', :env_var_is_blank, '', '')).to eq errors[:organizations_is_blank]}
        end
        context 'if file not found then message' do
          it {expect(subject.format_error('TICKETS environment variable', :env_var_file_not_found, '', '')).to eq errors[:tickets_file_not_found]}
          it {expect(subject.format_error('USERS environment variable', :env_var_file_not_found, '', '')).to eq errors[:users_file_not_found]}
          it {expect(subject.format_error('ORGANIZATIONS environment variable', :env_var_file_not_found, '', '')).to eq errors[:organizations_file_not_found]}
        end
        context 'if file not readable then message' do
          it {expect(subject.format_error('TICKETS environment variable', :env_var_file_not_readable, '', '')).to eq errors[:tickets_file_not_readable]}
          it {expect(subject.format_error('USERS environment variable', :env_var_file_not_readable, '', '')).to eq errors[:users_file_not_readable]}
          it {expect(subject.format_error('ORGANIZATIONS environment variable', :env_var_file_not_readable, '', '')).to eq errors[:organizations_file_not_readable]}
        end
        context 'if file causes an exception then message' do
          it {expect(subject.format_error('TICKETS environment variable', :env_var_file_error, '', 'Dummy Exception')).to eq errors[:tickets_file_caused_exception]}
          it {expect(subject.format_error('USERS environment variable', :env_var_file_error, '', 'Dummy Exception')).to eq errors[:users_file_caused_exception]}
          it {expect(subject.format_error('ORGANIZATIONS environment variable', :env_var_file_error, '', 'Dummy Exception')).to eq errors[:organizations_file_caused_exception]}
        end
        context 'if file is not valid json then message' do
          it {expect(subject.format_error('TICKETS environment variable file [dummy_file]', :env_var_invalid_json, '', '')).to eq errors[:tickets_file_not_json]}
          it {expect(subject.format_error('USERS environment variable file [dummy_file]', :env_var_invalid_json, '', '')).to eq errors[:users_file_not_json]}
          it {expect(subject.format_error('ORGANIZATIONS environment variable file [dummy_file]', :env_var_invalid_json, '', '')).to eq errors[:organizations_file_not_json]}
        end
      end
    end
  end
end
# rubocop:enable Layout/SpaceInsideBlockBraces, Metrics/LineLength
