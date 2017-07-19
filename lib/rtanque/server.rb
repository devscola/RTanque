require 'faye/websocket'
require 'rack'
require 'eventmachine'
require 'json'


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

module RTanque
  class Server

    def initialize match, port = 8080, interval = 1, audience = 0
      @match = match
      @interval = interval
      @audience = audience
      @port = port

      Faye::WebSocket.load_adapter('thin')

      trap :INT do
        EventMachine.stop
      end

      Thread.new do
        thin = Rack::Handler.get('thin')
        thin.run method(:server), :Port => port, :Host => '0.0.0.0'
      end
    end

    def method_missing(method, *args, &block)
      @match.send(method, *args, &block)
    end

    def tick
      return if pool.size < @audience
      @match.tick
      at_tick_interval(@interval) {
        transmit @match.snapshot.to_json
      }
    end

    def start
      self.tick until self.finished?
    end

    private

      def at_tick_interval(num_of_ticks)
        yield if @match.ticks % num_of_ticks == 0
      end

      def transmit message
        pool.send message
      end

      def pool
        @pool ||= Conections::Pool.new
      end

      def server env
        if Faye::WebSocket.websocket?(env)
          ws = Faye::WebSocket.new(env)

          ws.on :close do |event|
            ws = nil
            pool.delete event.target
          end

          ws.on :open do |x|
            pool.add x.target
            ws.send({arena: @match.arena.to_h}.to_json)
          end

          ws.rack_response

        else
          [
            200,
            {'Content-Type' => 'text/html'},
            File.read(File.expand_path('../public/index.html', __FILE__)).gsub(
              /__(HOST|PORT)__/, {
                '__PORT__' => @port,
                '__HOST__' => Rack::Request.new(env).host
              }
            )
          ]
        end
      end
  end
end


