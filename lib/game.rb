require_relative('deck')
require_relative('playing_card')
require_relative('player')
require('pry')

class Game
  attr_accessor :players, :current_player, :message, :go_fish_toggle
  attr_reader :deck, :clients
  def initialize(clients = [])
    @clients = clients
    @players = []
    @deck = Deck.new.shuffle
    @current_player = nil
    @message = ''
    @go_fish_toggle = false
  end

  def add_player(player)
    clients.push(player)
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
    if players.length < 4
      @num = 7
    elsif players.length >= 4
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

  def play_round(rank, player)
    next_players_turn
    play_turn(rank, player)
    results_string = ''
    players.each do |i|
      results_string << "#{i.name} has #{i.hand_length} cards in hand and #{i.sets.length} sets "
    end
    results_string
  end

  def play_turn(rank, player)
    request_cards(rank, player) until message == 'Go Fish!'
    go_fish
  end

  def request_cards(rank, player)
    if player.have_any?(rank)
      player.give_cards(current_player, rank)
    else
      @go_fish_toggle = true
      @message = 'Go Fish!'
    end
  end

  def go_fish
    if !deck.empty?
      current_player.add_cards(deal)
      @go_fish_toggle = false
      @message = "#{current_player.name} went fishing!"
      # next_players_turn
    else
      next_players_turn
      @go_fish_toggle = false
      @message = "There are no more fish to catch:(\n It is #{current_player.name}'s turn."
    end
  # next_players_turn
  end

  def next_players_turn
    self.current_player = (current_player.nil? ? players[0] : players[turn_index])
    @message = "It is #{current_player.name}'s turn. Select a player, then a card to ask for."
    self.current_player
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
    players.each { |player| total_sets = (total_sets + player.sets.length) }
    total_sets
  end

  def most_sets
    players.max_by do |player|
      player.sets.length
    end
  end

  def winner
    @message = "Winner: #{most_sets.name}" if sets_total == 13
  end

  private

  attr_writer :deck
end
