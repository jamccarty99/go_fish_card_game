require 'socket'
require 'pry'
require_relative '../lib/client_socket'

class MockServer
  attr_reader :port, :output

  def initialize(port)
    @port = port
    @socket = TCPServer.new(port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def accept
    socket = @socket.accept_nonblock
    socket.puts('Welcome') if socket
    sleep(0.1)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket.close if @socket
  end
end

describe 'ClientSocket' do
  attr_reader :clients, :socket
  def user_input(string)
    allow(STDIN).to receive(:gets) { string }
  end
  let(:server) { MockServer.new(3333) }

  before(:each) do
    @clients = []
    @socket = ClientSocket.new(server.port)
    clients.push(socket)
    socket.start
  end

  after(:each) do
    server.close
  end

  describe 'capture_output' do
    it 'Tells me it is waiting for another player when asked to play' do
      server.accept
      expect(socket.capture_output).to eq("Welcome\n")
    end
  end

  describe 'provide_input' do
    xit '' do
    end
  end
end
