require_relative '../lib/deck'

describe 'CardDeck' do
  let(:deck) { Deck.new }
  let(:ace_spades) { PlayingCard.new('Ace', 'Spades') }
  let(:queen_spades) { PlayingCard.new('Queen', 'Spades') }
  let(:four_hearts) { PlayingCard.new('4', 'Hearts') }
  let(:deck_of_2) { [PlayingCard.new('Queen', 'Spades'), PlayingCard.new('4', 'Spades')] }

  describe 'start' do
    it 'Should have 52 cards when started' do
      test = deck.start
      expect(deck.cards_left(test)).to eq 52
    end
  end

  describe 'cards_left' do
    it 'Should return how many cards are left in the deck' do
      expect(deck.cards_left(deck_of_2)).to eq 2
    end
  end

  describe 'deal' do
    it 'Should take a card from the deck' do
      card = deck.deal(deck_of_2)
      expect(card.rank).to match(/Queen/)
      expect(card.suit).to match(/Spades/)
    end
  end

  describe 'shuffle!' do
    it 'Should shuffle the deck of cards' do
      expect(deck.start).to_not be_nil
      expect(deck.shuffled_deck).to_not eq deck.ordered_deck
    end
  end
end
