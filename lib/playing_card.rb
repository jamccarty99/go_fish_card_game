class PlayingCard
  VALUES = {
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "10" => 9,
    "Jack" => 10,
    "Queen" => 11,
    "King" => 12,
    "Ace" => 13
  }
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
	   "#{@rank} of #{@suit}"
	end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def value
    VALUES[rank]
  end
end
