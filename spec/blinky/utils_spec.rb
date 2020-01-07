# frozen_string_literal: true

require 'spec_helper'

require_relative '../../blinky/constants'
require_relative '../../blinky/utils'

class TestingUtils
  include Blinky::Utils
end

describe TestingUtils do
  context '#err' do
    it {expect(subject.err(:env_var_not_present)).to eq 'is not present'}
    it {expect(subject.err(:env_var_is_blank)).to eq 'is blank'}
    it {expect(subject.err(:env_var_file_not_found)).to eq 'does not name an existing file'}
    it {expect(subject.err(:env_var_file_not_a_file)).to eq 'is not a file'}
    it {expect(subject.err(:env_var_file_not_readable)).to eq 'does not name a readable file'}
  end
end
