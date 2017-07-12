require 'json'
require 'ap'

module RTanque

  class Broadcaster
    def transmit message
      ap message
    end
  end

  class BroadcastedMatch < BasicObject

    def initialize match, broadcaster = Broadcaster.new
      @match = match
      @broadcaster = broadcaster
      Bot.include(Serializable::Bot)
      Shell.include(Serializable::Shell)
      Explosion.include(Serializable::Explosion)
      Match.include(Serializable::Match)
    end

    def method_missing(method, *args, &block)
      @match.send(method, *args, &block)
    end

    def tick
      @match.tick
      broadcast
    end

    def start
      self.tick until self.finished?
    end

    def broadcast
      @broadcaster.transmit snapshot.to_json
    end

    private

    def snapshot
      {
        tick: ticks,
        scene: to_h
      }
    end
  end
end
