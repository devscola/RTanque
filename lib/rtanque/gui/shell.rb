require 'gosu'

module RTanque
  module Gui
    class Shell
      attr_reader :shell

      DEBUG = ENV["DEBUG_SHELLS"]
      WHITE  = Gosu::Color::WHITE
      RED  = Gosu::Color::RED

      def initialize(window, shell)
        @window = window
        @shell = shell
        @x0 = shell.position.x
        @y0 = @window.height - shell.position.y
      end

      def draw
        position = [self.shell.position.x, @window.height - self.shell.position.y]

        if DEBUG then
          pos = shell.position
          x1, y1 = pos.x, @window.height - pos.y
          @window.draw_line @x0, @y0, WHITE, x1, y1, WHITE, ZOrder::SHELL
          return
        end

        @window.draw_quad \
        position[0]-4, position[1]-4, RED,\
        position[0]-4, position[1]+4, RED,\
        position[0]+4, position[1]-4, RED,\
        position[0]+4, position[1]+4, RED,\
        ZOrder::SHELL
      end
    end
  end
end
