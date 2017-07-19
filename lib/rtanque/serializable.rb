module RTanque
  module Serializable
    module Bot
      def to_h
        {
          name: name,
          health: health,
          heading: heading.radians,
          position: position.to_h.reject{ |k,_|
            k == :arena
          },
          radar: {
            heading: radar.heading.radians
          },
          turret: {
            heading: turret.heading.radians
          }
        }
      end
    end

    module Shell
      def to_h
        {
          heading: heading.radians,
          position: position.to_h.reject{ |k,_| k == :arena}
        }
      end
    end

    module Explosion
      def to_h
        {
          position: position.to_h.reject{ |k,_| k == :arena}
        }
      end
    end

    module Match
      def to_h
        {
          # arena: arena.to_h,
          bots: bots.map(&:to_h),
          shells: shells.map(&:to_h),
          explosions: explosions.map(&:to_h)
        }
      end
    end
  end
end
