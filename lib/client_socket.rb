require 'socket'

class ClientSocket
  attr_reader :port, :socket

  def initialize(port)
    @port = port
  end

  def start
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    ""
  end

  def close
    @socket.close if @socket
  end
end
