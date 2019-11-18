# frozen_string_literal: true

require 'spec/spec_helper'

require 'blinky/constants'
require 'blinky/schema/matcher'

# rubocop:disable Metrics/LineLength, Layout/SpaceInsideBlockBraces, Layout/AlignHash
describe Blinky::Schema::Matcher do
  describe 'private methods' do
    context '#must_be_a_string' do
      context('should fail if') do
        it 'value is an integer' do
          expect(subject.send(:must_be_string, :irrelevant, 123)).to be false
        end
        it 'value is a nil' do
          expect(subject.send(:must_be_string, :irrelevant, nil)).to be false
        end
      end
      context 'should succeed if' do
        it 'value is a string' do
          expect(subject.send(:must_be_string, :irrelevant, '')).to be true
        end
      end
    end
  end
end
# rubocop:enable Metrics/LineLength, Layout/SpaceInsideBlockBraces, Layout/AlignHash
