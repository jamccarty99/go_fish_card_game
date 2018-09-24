require_relative('deck')
require_relative('playing_card')
require_relative('player')
require('pry')

class Game
  attr_accessor :players, :current_player
  attr_reader :deck, :clients
  def initialize(clients)
    @clients = clients
    @players = []
    @deck = Deck.new.shuffle
    @current_player = nil
  end

  def start
    create_players(clients)
    size_of_game(players)
    deal_hand(@num)
  end

  def create_players(clients = [])
    clients.each do |player|
      players.push(Player.new(player))
    end
  end

  def size_of_game(players = [])
    @num = 7
    if (players.length) < 4
      @num = 7
    elsif (players.length) >= 4
      @num = 5
    end
  end

  def deal_hand(num = 7)
    1.upto(num) do
      players.each do |player|
        player.hand.push(deal(deck))
      end
    end
  end

  def deal(deck = @deck)
    deck.shift
  end

  def play_round
    next_players_turn
    play_turn
    results_string = ""
    players.each do |player|
      results_string << "#{player.name} has #{player.hand_length} cards in hand and #{player.sets.length} sets "
    end
    results_string
  end

  def play_turn
    until "Go Fish!"
      current_player.request_cards(rank, player)
    end
    go_fish
  end

  def request_cards(rank, player)
    if player.have_any?(rank)
      player.give_cards(current_player, rank)
    else
      "Go Fish!"
    end
  end

  def go_fish
    if deck.length != 0
      current_player.add_cards(deal)
      "#{current_player.name} went fishing!"
    else
      "There are no more fish to catch:("
    end
  end

  def next_players_turn
    if current_player == nil
      self.current_player = players[0]
    else
      self.current_player = players[turn_index]
    end
  end

  def turn_index
    last_index = (players.length - 1)
    if players.index(current_player) < last_index
      (players.index(current_player) + 1)
    elsif players.index(current_player) == last_index
      0
    end
  end

  def sets_total
    total_sets = 0
    players.each{ |player|  total_sets = (total_sets + player.sets.length) }
    total_sets
  end

  def most_sets
    players.max_by do |player|
      player.sets.length
    end
  end

  def winner
    if sets_total == 13
      "Winner: #{most_sets.name}"
    end
  end

  private
  attr_writer :deck
end
