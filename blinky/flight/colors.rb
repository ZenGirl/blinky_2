module Blinky
  module Flight
    module Colors
      def set_colors
        @red_on    = "\033[0;31m"
        @green_on  = "\033[0;32m"
        @yellow_on = "\033[0;33m"
        @blue_on   = "\033[0;34m"
        @purple_on = "\033[0;35m"
        @cyan_on   = "\033[0;36m"
        @white_on  = "\033[0;37m"
        @color_off = "\033[0m"
      end
    end
  end
end