# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/utils'
require 'blinky/models/invalid_keys_exception'
require 'blinky/models/user'
require 'blinky/pre_flight/interactors/load_users'

# rubocop:disable Metrics/LineLength, Layout/SpaceInsideBlockBraces
describe Blinky::PreFlight::Interactors::LoadUsers do
  describe 'private methods' do
    context '#load_and_validate' do
      context 'should fail if' do
        it 'row keys do not match schema keys' do
          expect {subject.send(:load_and_validate, 'spec/support/good_file.json')}.to raise_error Blinky::Models::InvalidKeysException
        end
        it 'row key value does not match schema' do
          expect {subject.send(:load_and_validate, 'spec/support/one_bad_user.json')}.to raise_error Blinky::Models::InvalidKeysException
        end
        it 'number of errors exceeds MAX_USERS_ERRORS' do
          expect {subject.send(:load_and_validate, 'spec/support/one_good_user.json')}.to raise_error Blinky::Models::InvalidKeysException
        end
        it 'number of rows exceeds MAX_USERS_ROWS' do

        end
      end
      context 'should succeed if' do
        it 'limited number of errors and rows' do

        end
      end
    end
  end
end
# rubocop:enable Metrics/LineLength, Layout/SpaceInsideBlockBraces
