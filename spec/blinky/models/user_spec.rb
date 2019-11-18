# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/utils'
require 'blinky/matcher'
require 'blinky/models/invalid_keys_exception'
require 'blinky/models/user'

# rubocop:disable Metrics/LineLength, Layout/SpaceInsideBlockBraces, Layout/AlignHash
describe Blinky::Models::User do
  describe 'private methods' do
    context '#row_keys_must_match_schema' do
      context 'should fail if' do
        let(:one_bad_user) do
          {
            _id:             'not an integer',
            url:             'not a url',
            external_id:     'not a guid',
            name:            123,
            alias:           234,
            created_at:      'not a date',
            active:          'gumby',
            verified:        'gonzo',
            shared:          'Hunter',
            locale:          'Thompson',
            timezone:        'Not a real place',
            last_login_at:   'not a date',
            email:           'not an email',
            phone:           'not a phone number',
            signature:       3456,
            organization_id: nil,
            tags:            [4567, 5678],
            suspended:       'not a boolean',
            role:            'Pelosi'
          }
        end
        before :all do
          @obj = Blinky::Models::User.new
        end
        it 'row keys do not match schema keys' do
          row = {
            alpha: 'alpha'
          }
          expect {@obj.send(:row_keys_must_match_schema, row)}.to raise_error Blinky::Models::InvalidKeysException
        end
        it 'row key value does not match schema' do
          expect {@obj.send(:row_values_must_match_schema, one_bad_user)}.to raise_error Blinky::Models::InvalidKeysException
        end
      end
      # context 'should succeed if' do
      #   it 'limited number of errors and rows' do
      #
      #   end
      # end
    end
  end
end
# rubocop:enable Metrics/LineLength, Layout/SpaceInsideBlockBraces, Layout/AlignHash
