module RTanque
  module Serializable

    def self.rounded number
      number.round 3
    end

    def self.normalize position
      position.to_h.reject { |k,_|
        k == :arena
      }.map { |coordinate, value|
        [coordinate, rounded(value)]
      }.to_h
    end

    module Bot
      def to_h
        {
          name: name,
          health: Serializable.rounded(health),
          heading: Serializable.rounded(heading.radians),
          dead: dead?,
          position: Serializable.normalize(position),
          radar: {
            heading: Serializable.rounded(radar.heading.radians)
          },
          turret: {
            heading: Serializable.rounded(turret.heading.radians)
          }
        }
      end
    end

    module Shell
      def to_h
        {
          heading: Serializable.rounded(heading.radians),
          position: Serializable.normalize(position)
        }
      end
    end

    module Explosion
      def to_h
        {
          position: Serializable.normalize(position)
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
