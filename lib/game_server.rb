require 'socket'
require_relative 'server_client'
require_relative 'game'
require 'pry'

class GameServer
  attr_reader :port, :server

  def initialize(port)
    @port = port
    @server = TCPServer.new(port)
  end

  def pending_clients
    @pending_clients ||= []
  end

  def players_in_game
    @players_in_game ||= {}
  end

  def games
    @games ||= []
  end

  def accept_new_client(player_name = "Random Player")
    client = ServerClient.new(server.accept_nonblock, player_name)
    # associate player and client
    pending_clients.push(client)
    client.provide_input(pending_clients.length.odd? ? "Welcome.  Waiting for another player to join." : "Welcome.  Are you ready to go fishing!")
    client
  rescue IO::WaitReadable, Errno::EINTR
    puts ""
  end

  def create_game_if_possible
    if pending_clients.length > 1
      game = Game.new(pending_clients)
      games.push(game)
      players_in_game[game] = pending_clients.shift(2)
      game.start
      # set_info(game)
      game
    end
  end

  def game_messages(game, text)
    players_in_game[game][0].connection.puts(text)
    players_in_game[game][1].connection.puts(text)
  end

  # def set_info(game)
  #   player1_sets = "#{game.players[0]} has #{game.players[0].sets.length} sets. "
  #   player2_sets = "#{game.players[1]} has #{game.players[1].sets.length} sets."
  #   player_info = player1_sets + player2_sets
  #   game_messages(game, player_info)
  # end

  def run_game(game)
    # spawn a thread
    threads = []
    Thread.start() do
      game_runner = GameRunner.new(game, @players_in_game[game])
      game_runner.start
    end
    # threads << thread1 =
    # threads.each { |thr| thr.join }
  end

  def close
    server.close if server
  end
end
