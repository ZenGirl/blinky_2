require 'spec_helper'

require 'constants'

describe Blinky::Constants do
  describe 'ENV_VAR_NAMES' do
    it('must have TICKETS') {expect(subject::ENV_VAR_NAMES.include?('TICKETS')).to be true}
    it('must have USERS') {expect(subject::ENV_VAR_NAMES.include?('USERS')).to be true}
    it('must have ORGANIZATIONS') {expect(subject::ENV_VAR_NAMES.include?('ORGANIZATIONS')).to be true}
  end
  describe 'MESSAGES' do
    it('must be a hash') {expect(subject::MESSAGES.is_a?(Hash))}
  end
  describe 'SCHEMAS' do
    it('must be a hash') {expect(subject::SCHEMAS.is_a?(Hash))}
  end
end
