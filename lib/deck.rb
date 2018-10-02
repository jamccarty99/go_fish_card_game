require_relative 'playing_card'

class Deck
  attr_reader :deck
  RANK = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze
  SUIT = %w[Clubs Diamonds Hearts Spades].freeze

  def initialize
    @deck = start
  end

  def start
    RANK.map { |rank| SUIT.map { |suit| PlayingCard.new(rank, suit) } }.flatten
  end

  def deal(deck = @deck)
    deck.shift
  end

  def shuffle
    deck.shuffle
  end

  def cards_left(deck)
    deck.length
  end

  def ordered_deck
    deck.collect(&:to_s)
  end

  def shuffled_deck
    shuffled = deck.shuffle
    shuffled.collect(&:to_s)
  end
end
