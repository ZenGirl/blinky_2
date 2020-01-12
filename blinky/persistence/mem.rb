# frozen_string_literal: true

module Blinky
  module Repository
    class Mem
      attr_accessor :organizations, :tickets, :users

      def initialize
        @organizations = []
        @tickets       = []
        @users         = []
      end


    end
  end
end