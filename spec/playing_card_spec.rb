require_relative '../lib/playing_card'

describe 'PlayingCard' do
  let(:card) { PlayingCard.new('Ace', 'Spades') }

  it 'returns suit and rank' do
    expect(card.rank).to eq 'Ace'
  end

  it 'returns rank' do
    expect(card.suit).to eq 'Spades'
  end

  it 'returns value' do
    expect(card.value).to eq 13
  end
end
