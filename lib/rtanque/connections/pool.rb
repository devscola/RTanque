module Conections
  class Pool

    def initialize
      @connections ||= []
    end

    def add connection
      @connections << connection
    end

    def delete connection
      @connections.delete connection
    end

    def send message
      @connections.each do |connection|
        connection.send(message)
      end
    end

    def empty?
      @connections.empty?
    end

    def size
      @connections.length
    end
  end
end
