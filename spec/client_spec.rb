require 'socket'
require 'pry'
require_relative '../lib/client'
# binding.pry
# @socket = TCPServer.new(3333)

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
    client = @socket.accept_nonblock
    client.puts("Welcome")if client
    sleep(0.1)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe 'Client' do
  def user_input(string)
    allow(STDIN).to receive(:gets) { string }
  end

  before(:each) do
    @server = MockServer.new(3333)
  end

  after(:each) do
    @server.close
  end

  describe 'start'do
    it 'Sends a greating at start' do
      @client1 = Client.new(@server.port)
      expect{ @client1.start }.to output("Do you want to play?\n").to_stdout
    end

    it 'Tells me it is waiting for another player when asked to play' do
      @client1 = Client.new(@server.port)
      @client1.start
      user_input("Yes")
      @server.accept
      expect { @client1.give_instructions }.to  output("Welcome\n").to_stdout
    end

    describe'Interpreting instructions' do
      before(:each) do
        @client1 = Client.new(@server.port)
        @client1.start
        user_input("Yes")
        @server.accept
        @client1.give_instructions
        #make sure it is the corresponding players turn
      end

      it 'interprets asking another player for cards' do
        question = 'Joey for 3s?'
        user_input(question)
        expect(question).to match /(ask\s*|)(\S+) for (\D+|\d+)s/
        #what should happen?
      end
    end
  end
end
