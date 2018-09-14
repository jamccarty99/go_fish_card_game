require_relative('deck')
require_relative('playing_card')
require_relative('player')
require('pry')

class Game
  attr_accessor :players
  attr_reader :deck, :clients
  def initialize(clients)
    @clients = clients
    @players = []
    @deck = Deck.new.shuffle
  end

  def start
    create_players(clients)
    size_of_game(players)
    deal_hand(@num)
  end

  def create_players(clients)
    clients.each { |player| players.push(Player.new(player)) }
  end

  def deal_hand(num)
    1.upto(num) do
      players.each do |player|
        player.hand.push(deal(deck))
      end
    end
  end

  def size_of_game(players)
    @num = 0
    if (players.length) < 4
      @num = 7
    elsif (players.length) >= 4
      @num = 5
    end
  end

  def deal(deck = @deck)
    deck.shift
  end

  def play_round
    #whose_turn
    #have_any?
    #give_cards
    #go_fish
  end

  def sets_total
    13
  end

  def most_sets
    player1
  end

  def winner
    if sets_total == 13
      "Winner: #{players[0]}"
    end
  end


end
