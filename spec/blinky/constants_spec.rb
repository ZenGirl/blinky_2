require 'spec/spec_helper'

require 'blinky/constants'

# rubocop:disable Metrics/LineLength
# We're going to disable rubocop messages as they clutter up the spec with '~' in RubyMine
describe Blinky::Constants do
  describe 'ENV_VAR_NAMES' do
    it 'must have TICKETS' do
      expect(subject::ENV_VAR_NAMES.include?('TICKETS')).to be true
    end
    it 'must have USERS' do
      expect(subject::ENV_VAR_NAMES.include?('USERS')).to be true
    end
    it 'must have ORGANISATIONS' do
      expect(subject::ENV_VAR_NAMES.include?('ORGANISATIONS')).to be true
    end
  end

  # rubocop:disable Layout/SpaceInsideBlockBraces
  describe 'for MESSAGES' do
    context 'not_present key value' do
      it {expect(subject::MESSAGES[:not_present]).to eq('environment variable is not present')}
    end
    context 'not_usable key value' do
      it {expect(subject::MESSAGES[:not_usable]).to eq('environment variable is blank')}
    end
    context 'not_readable key value' do
      it {expect(subject::MESSAGES[:not_readable]).to eq('does not name a readable file')}
    end
    context 'not_found key value' do
      it {expect(subject::MESSAGES[:not_found]).to eq('does not name an existing file')}
    end
  end
  # rubocop:enable Layout/SpaceInsideBlockBraces

  # rubocop:disable Layout/SpaceInsideBlockBraces
  describe 'for SCHEMAS' do
    context 'ticket key' do
      it {expect(subject::SCHEMAS[:ticket]).to_not be nil}
    end
    context 'user key' do
      it {expect(subject::SCHEMAS[:user]).to_not be nil}
    end
    context 'organization key' do
      it {expect(subject::SCHEMAS[:organization]).to_not be nil}
    end
  end
  # rubocop:enable Layout/SpaceInsideBlockBraces
end
# rubocop:enable Metrics/LineLength
