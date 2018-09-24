require 'socket'
require_relative '../lib/game_server'

class MockClient
  attr_reader :socket

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    ""
  end

  def close
    socket.close if socket
  end
end

describe GameServer do
  attr_reader :clients, :server
  before(:each) do
    @clients = []
    @server = GameServer.new(3336)
  end

  after(:each) do
    server.close
    clients.each do |client|
      client.close
    end
  end

  it "accepts new clients and starts a game if possible" do
    server
    client1 = MockClient.new(server.port)
    clients.push(client1)
    server.accept_new_client("Player 1")
    server.create_game_if_possible
    expect(server.games.count).to be 0
    client2 = MockClient.new(server.port)
    clients.push(client2)
    server.accept_new_client("Player 2")
    server.create_game_if_possible
    expect(server.games.count).to be 1
  end
end

  describe GameServer do
    let(:game) { Game.new(["player1", "player2"]) }

    before(:each) do
      clients = []
      server = GameServer.new(3336)
      client1 = MockClient.new(server.port)
      clients.push(client1)
      server.accept_new_client("Player 1")
      server.create_game_if_possible
      client2 = MockClient.new(server.port)
      clients.push(client2)
      server.accept_new_client("Player 2")
    end

    after(:each) do
      server.close
      clients.each do |client|
        client.close
      end
    end

    describe 'set_info' do
      xit 'Should send players a message with their set count' do
        game.start
        clients.map{ |client| client.capture_output}
        server.create_game_if_possible
        test_client_output(/cards left/)
      end
    end

    describe 'gameMessages' do
      xit 'Should send players a message with text passed in' do
        game.start
        clients.map{ |client| client.capture_output}
        server.create_game_if_possible
        test_client_output(/Ready to begin/)
      end
    end

    xit 'creates a new thread for every game and keeps them in an array' do
      server.create_game_if_possible
      server.run_game(game)
      expect(server.run_game(game).thread.count).to eq 1
    end
  end

  def test_client_output(expected_output)
    expect(clients[0].capture_output).to match (expected_output)
    expect(clients[1].capture_output).to match (expected_output)
  end
