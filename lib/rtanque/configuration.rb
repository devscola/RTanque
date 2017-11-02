module RTanque
  class Configuration
    ONE_DEGREE = (Math::PI / 180.0)


    def self.raise_brain_tick_errors
      true
    end

    def self.quit_when_finished
      true
    end

    def self.bot
      @bot ||= Bot.new
    end

    def self.turret
      @turret ||= Turret.new
    end

    def self.radar
      @radar ||= Radar.new
    end

    def self.shell
      @shell ||= Shell.new
    end

    def self.explosion
      @explosion ||= Explosion.new
    end

    def self.gui
      @gui ||= Gui.new
    end

    private
      class Bot
        def radius
          19
        end

        def health_reduction_on_exception
          2
        end

        def health
          0..100
        end

        def speed
          -3..3
        end

        def speed_step
          0.05
        end

        def turn_step
          ONE_DEGREE * 1.5
        end

        def fire_power
          1..5
        end

        def gun_energy_max
          10
        end

        def gun_energy_factor
          10
        end
      end

      class Turret
        def length
          28
        end

        def turn_step
          (ONE_DEGREE * 2.0)
        end
      end

      class Radar
        def turn_step
          0.05
        end

        def vision
          -(ONE_DEGREE * 10.0)..(ONE_DEGREE * 10.0)
        end
      end

      class Shell
        def speed_factor
          4.5
        end

        def ratio
          1.5 # used by Bot#adjust_fire_power and to calculate damage done by shell to bot
        end
      end

      class Explosion
        def life_span
          70 * 1 # should be multiple of the number of frames in the explosion animation
        end
      end

      class Gui
        class Fonts
          def small
            16
          end
        end

        def update_interval
          16.666666
        end

        def fonts
          @fonts ||= Fonts.new
        end
      end
    end
end
