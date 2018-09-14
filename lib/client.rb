require 'socket'

class Client
  attr_reader :port
  
  def initialize(port)
    @port = port
  end

  def start
    puts "Do you want to play?"
    @socket = TCPSocket.new('localhost', port)
  end

  def give_instructions
    puts @socket.read_nonblock(1000)
  end
end
