require('sinatra')
require('sinatra/reloader')
require 'sprockets'
require 'sass'
require('pry')
require_relative('lib/player')
require_relative 'lib/game'

class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  enable :sessions
  # Start Assets
  set :environment, Sprockets::Environment.new
  environment.append_path 'assets/images/cards'
  environment.append_path 'assets/images'
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/javascripts'
  environment.css_compressor = :scss
  get '/assets/*' do
    env['PATH_INFO'].sub!('/assets', '')
    settings.environment.call(env)
  end

  def self.game
    @@game ||= Game.new
  end

  get '/login' do
    slim :login
  end

  post '/login' do
    session[:username] = params[:username]
    redirect '/'
  end

  get '/' do
    slim :main, locals: { username: session[:username] }
  end

  get '/size' do
    slim :size, locals: { username: session[:username] }
  end

  post '/waiting' do
    session[:size] = params[:size]
    self.class.game.add_player(session[:username])
    if self.class.game.clients.length == session[:size].to_i
      session[:opponent_name] = self.class.game.clients[0]
      self.class.game.start
      self.class.game.next_players_turn
      session[:current_user] = self.class.game.players.find { |player| player.name == session[:username] }
      session[:opponent] = self.class.game.players.find { |player| player.name == session[:opponent_name] }
      redirect '/game'
    else
      redirect '/waiting'
    end
  end

  get '/settings' do
    slim :settings, locals: { game: self.class.game, current_user: session[:current_user], size: session[:size], username: session[:username] }
  end

  get '/rules' do
    slim :rules
  end

  get '/waiting' do
    if self.class.game.clients.length == session[:size].to_i
      session[:opponent_name] = self.class.game.clients[1]
      session[:current_user] = self.class.game.players.find { |player| player.name == session[:username] }
      session[:opponents] = self.class.game.players.find { |player| player.name == session[:opponent_name] }
      redirect '/game'
    else
      timer
      slim :waiting, locals: { game: self.class.game, size: session[:size], username: session[:username], opponent_name: session[:opponent_name] }
    end
  end

  get '/game' do
    current_user = self.class.game.players.find { |player| player.name == session[:username] }
    session[:message] = self.class.game.message
    slim :two_player, locals: { game: self.class.game, current_user: current_user, username: session[:username], opponent_name: session[:opponent_name], opponents: session[:opponents], message: session[:message] }
  end

  post '/game' do
    game = self.class.game
    card = params.fetch('asked_card')
    requested_player = params.fetch('asked_player')
    requested = self.class.game.players.find { |player| player.name == requested_player }
    game.play_turn(card, requested)
    session[:message] = self.class.game.message
    redirect '/game'
  end

  def self.reset
    @@game = Game.new
  end

  def timer
    # start a timer
    # when timer hits two minutes, add_bot to the game
    # bot will randomly select players and cards. Everything else will be automatic
  end

  # post '/join' do
  #   player = Player.new(params.fetch['username'])
  #   session[:current_user] = player
  #   self.class.game.add_player(player)
  #   redirect '/game'
  # end
  #
  # get '/game' do
  #   redirect '/' if self.class.game.empty?
  #   slim :game, locals: { game:self.class.game, current_user: session[:current_user] }
  # end
end
