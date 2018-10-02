require'rack/test'
require'rspec'
require'capybara'
require'capybara/dsl'
ENV['RACK_ENV'] = 'test'
require_relative '../server'

RSpec.describe Server do
  include Capybara::DSL

  before do
    Capybara.app = Server.new
  end

  after do
    Server.reset
  end

  it 'is possible to login' do
    visit '/login'
    fill_in :username, with: 'John'
    click_on 'Login'
    expect(page).to have_content('Welcome')
    expect(page).to have_content('John')
  end

  it 'is possible to select Play Game' do
    visit '/login'
    fill_in :username, with: 'John'
    click_on 'Login'
    click_on 'Play Game'
    expect(page).to have_content('2 Player')
  end

  it 'is possible learn how to play the game' do
    visit '/login'
    fill_in :username, with: 'John'
    click_on 'Login'
    click_on 'How to Play'
    expect(page).to have_content('How to Play')
    expect(page).to have_content('OBJECT OF THE GAME')
  end

  it 'is possible to select a game size and wait for other players to join' do
    visit '/login'
    fill_in :username, with: 'John'
    click_on 'Login'
    click_on 'Play Game'
    click_on '2 Player'
    expect(page).to have_content('Waiting').or have_content('It\'s your turn! Select a card to ask for!')
  end

  describe '/game' do
    before do
      session1 = Capybara::Session.new(:rack_test, Server.new)
      session2 = Capybara::Session.new(:rack_test, Server.new)
      [session1, session2].each_with_index do |session, index|
        player_name = "Player #{index + 1}"
        session.visit '/login'
        session.fill_in :username, with: player_name
        session.click_on 'Login'
        expect(session).to have_content(player_name)
        session.click_on 'Play Game'
        session.click_on '2 Player'
      end
    end

    after do
      Server.reset
    end

    it 'allows multiple players to join game' do
      session1 = Capybara::Session.new(:rack_test, Server.new)
      session2 = Capybara::Session.new(:rack_test, Server.new)
      [session1, session2].each_with_index do |session, index|
        player_name = "Player #{index + 1}"
        session.visit '/login'
        session.fill_in :username, with: player_name
        session.click_on 'Login'
        expect(session).to have_content(player_name)
        session.click_on 'Play Game'
        session.click_on '2 Player'
      end
      expect(session1).to have_content('Waiting for one more player to join the Game...')
      # binding.pry
      expect(session2).to have_content('Player 1')
      # binding.pry
      session1.visit '/waiting'
      # binding.pry
      expect(session1).to have_content('Player 1')
    end

    it 'displays a different message for each player' do
      session1 = Capybara::Session.new(:rack_test, Server.new)
      session2 = Capybara::Session.new(:rack_test, Server.new)
      [session1, session2].each_with_index do |session, index|
        player_name = "Player #{index + 1}"
        session.visit '/login'
        session.fill_in :username, with: player_name
        session.click_on 'Login'
        expect(session).to have_content(player_name)
        session.click_on 'Play Game'
        session.click_on '2 Player'
      end
      expect(session1).to have_content('Waiting for one more player to join the Game...')
      session1.visit '/waiting'
      expect(session1).to have_content('Select a card to ask for!')
      session2.driver.refresh
      expect(session2).to have_content('It\'s player1\'s turn.')
    end

    xit 'displays the names and sets of each player on their avatar' do
      expect(session2).to have_content('Waiting')
      session1.driver.refresh
      expect(session1).to have_content
      session2.driver.refresh
      expect(session2).to have_content
    end
  end
end
