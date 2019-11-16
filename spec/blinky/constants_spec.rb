# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/constants'

# rubocop:disable Layout/SpaceInsideBlockBraces
describe Blinky::Constants do
  describe 'ENV_VAR_NAMES' do
    it('must have TICKETS') {expect(subject::ENV_VAR_NAMES.include?('TICKETS')).to be true}
    it('must have USERS') {expect(subject::ENV_VAR_NAMES.include?('USERS')).to be true}
    it('must have ORGANIZATIONS') {expect(subject::ENV_VAR_NAMES.include?('ORGANIZATIONS')).to be true}
  end

end
# rubocop:enable Layout/SpaceInsideBlockBraces
