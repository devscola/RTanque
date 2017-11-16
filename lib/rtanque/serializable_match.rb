module RTanque
  class SerializableMatch < BasicObject

    def initialize match
      @match = match
      Bot.include(Serializable::Bot) unless Bot.include? Serializable::Bot
      Shell.include(Serializable::Shell) unless Shell.include? Serializable::Shell
      Explosion.include(Serializable::Explosion) unless Explosion.include? Serializable::Explosion
      Match.include(Serializable::Match) unless Match.include? Serializable::Match
    end

    def method_missing(method, *args, &block)
      @match.send(method, *args, &block)
    end

    def snapshot
      {
        tick: ticks,
        scene: to_h
      }
    end
  end
end
