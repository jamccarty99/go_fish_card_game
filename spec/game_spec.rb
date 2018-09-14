require_relative '../lib/game'

describe 'Game' do
  let(:player1_card) { PlayingCard.new("Queen", "Spades") }
  let(:player2_card) { PlayingCard.new("4", "Hearts") }
  let(:game) { Game.new(["player1", "player2"]) }
  let(:game_of_5) { Game.new(["player1", "player2", "player3", "player4", "player5"])}
  let(:deck_of_2) { [ PlayingCard.new("Queen", "Spades"), PlayingCard.new("4", "Spades") ] }
  let(:deck_of_1) { [ PlayingCard.new("4", "Hearts") ] }

  # before :each do
  #   game.start()
  # end

  describe 'start' do
    it 'Should deal 5 cards to each player in a 4+ player game' do
      game_of_5.start
      expect(game_of_5.players[0].hand_length).to eq 5
    end
    it 'Should deal 7 cards to each player in a 2 or 3 player game' do
      game.start
      expect(game.players[0].hand_length).to eq 7
    end

    it 'Should create instances of each player' do
      game_of_5.start
      expect(game_of_5.players[0]).to be_instance_of(Player)
    end
  end

  describe 'deal' do
    it 'Should take a card from the deck' do
      card = game.deal(deck_of_2)
      expect(card.rank).to match /Queen/
      expect(card.suit).to match /Spades/
    end
  end

  describe 'sets_total' do
    it 'should count the total number of sets between all players in the game' do
      expect(game.sets_total).to eq 13
    end
  end

  describe 'play_round' do
    xit 'should play a round' do

    end
  end

  describe 'most_sets' do
    xit 'Should return the player with the most sets' do
      expect(game.most_sets).to eq player1
    end
  end
  describe 'winner' do
    it 'should declare the winner of the game' do
      expect(game.winner).to match /Winner/
    end
  end
end
