require_relative '../lib/game_runner'
#
# describe 'game_runner' do
#   it 'runs the game until there is a winner and puts a message' do
#     expect(game_runner).to match /Winner/
#   end
# end
describe'' do
  xit 'interprets asking another player for cards' do
    question = 'Joey for 3s?'
    user_input(question)
    expect(question).to match /(ask\s*|)(\S+) for (\D+|\d+)s/
    #what should happen?
  end
end
