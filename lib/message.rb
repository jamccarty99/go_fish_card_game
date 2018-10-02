class Message
  attr_accessor
  attr_reader :info

  def initialize(info)
    @info = info
  end

  def whose_turn
    # compare current_player to current_user user to determine message
    # "It is your turn! Select a player, then a card to ask for!"
    # or "It is current_player's turn."
  end

  def catch_result
    # compare current_player to current_user user to determine message
    # compare asked_player to current_user user to determine message
    # "You caught _ cards from asked_player"
    # "current_player caught _ cards from asked_player"
  end
end
