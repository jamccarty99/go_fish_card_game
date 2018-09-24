require_relative '../lib/game'

describe 'Game' do
  let(:player1_card) { PlayingCard.new("Queen", "Spades") }
  let(:player2_card) { PlayingCard.new("4", "Hearts") }
  let(:game) { Game.new(["player1", "player2"]) }
  let(:game_of_5) { Game.new(["player1", "player2", "player3", "player4", "player5"])}
  let(:deck_of_2) { [ PlayingCard.new("Queen", "Spades"), PlayingCard.new("4", "Spades") ] }
  let(:deck_of_1) { [ PlayingCard.new("4", "Hearts") ] }
  let(:set) {[PlayingCard.new("Queen", "Spades"), PlayingCard.new("Queen", "Clubs"), PlayingCard.new("Queen", "Hearts"), PlayingCard.new("Queen", "Diamonds")]}

  describe 'start' do
    it 'Should deal 5 cards to each player in a 4+ player game' do
      game_of_5.start
      expect(game_of_5.players[0].hand_length).to eq 5
      expect(game_of_5.players[0].hand_length).not_to eq 26
    end

    it 'Should deal 7 cards to each player in a 2 or 3 player game' do
      game.start
      expect(game.players[0].hand_length).to eq 7
      expect(game.players[0].hand_length).not_to eq 26
    end

    it 'Should create instances of each player' do
      game_of_5.start
      expect(game_of_5.players[4]).to be_instance_of(Player)
    end
  end

  describe 'deal' do
    it 'Should take a card from the deck' do
      card = game.deal(deck_of_2)
      expect(card.rank).to match /Queen/
      expect(card.suit).to match /Spades/
    end
  end

  describe 'play_round' do
    it 'should play a round of Go-Fish and display the current game details' do
      game.start
      game.next_players_turn
      expect(game.play_round).to match /player1 has/
      expect(game.play_round).not_to match /player1 has 26 cards in hand/
    end
  end

  describe 'play_turn' do
    it 'should play the current_players turn' do
      game.start
      game.next_players_turn
      expect(game.play_turn).to eq("There are no more fish to catch:(").or match /went fishing!/
    end
  end

  describe 'request_cards' do
    it 'Should give cards to the current_player if the player asked has at least one' do
      game.start
      game.next_players_turn
      empty_hand
      game.players[1].hand.push(player1_card)
      # expect(game.request_cards("Queen", game.players[1])).to match /received/
      expect{game.request_cards("Queen", game.players[1])}.to change{game.players[0].hand_length}.by(1)
    end

    it 'Should display a message if the player asked does not have the card' do
      game.start
      game.next_players_turn
      empty_hand
      expect(game.request_cards("Queen", game.players[1])).to match /Go Fish!/
    end

    def empty_hand
      until game.players[1].hand = [] do
        game.players[1].hand.shift
      end
    end
  end

  describe 'go_fish' do
    it 'Should deal a card to the current_player if there are cards in the deck' do
      game.start
      game.next_players_turn
      expect{game.go_fish}.to change{game.players[0].hand_length}.by(1)
    end

    it 'Should send the player a message if the deck is empty' do
      game.start
      game.next_players_turn
      game.send(:deck=, [])
      expect(game.go_fish).to eq "There are no more fish to catch:("
    end
  end

  describe 'next_players_turn' do
    it 'Should set current_player to the next players turn' do
      game_of_5.start
      game_of_5.next_players_turn
      expect(game_of_5.next_players_turn).not_to eq game_of_5.players[0]
      expect(game_of_5.next_players_turn).to eq game_of_5.players[2]
      expect(game_of_5.next_players_turn).to eq game_of_5.players[3]
    end
  end

  describe 'sets_total' do
    it 'should count the total number of sets between all players in the game' do
      game.start
      game.players[0].sets.push(set)
      expect(game.sets_total).to eq 1
    end
  end

  describe 'most_sets' do
    it 'Should return the player with the most sets' do
      game.start
      game.players[1].sets.push(set)
      expect(game.most_sets).not_to eq game.players[0]
      expect(game.most_sets).to eq game.players[1]
    end
  end
  describe 'winner' do
    it 'should declare the winner of the game' do
      game.start
      13.times do
        game.players[1].sets.push(set)
      end
      expect(game.winner).to match /Winner/
    end
  end
end
