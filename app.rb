require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'json'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each {|file| require file }

set :database, { adapter: 'postgresql',
  encoding: 'unicode', database: 'your_database_name', pool: 2,
  username: 'roman', password: 'password'}

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  use Rack::Session::Cookie

  get '/' do
    haml :index
  end

  get '/phrases' do
    { phrases: Phrase.all }.to_json
  end

  post '/phrase' do
    params_json = JSON.parse(request.body.read)
    { phrase: Phrase.create(params_json['phrase']) }.to_json
  end

  put '/phrase/:id' do
    params_json = JSON.parse(request.body.read)
    @phrase = Phrase.find(params[:id])
    @phrase.update(name: params_json['phrase'])
    { phrase: @phrase.name }.to_json
  end

  delete '/phrase/:id' do
    { message: Phrase.destroy(params[:id]) }.to_json
  end

  # post '/create_user' do
  #   User.create!(params[:user])
  #   session[:username] = params[:user][:username]
  #   flash[:info] = 'You successfull create self account!'
  # end
  #
  # post '/loggin' do
  #   @user = User.where(username: params[:user][:username])
  #   if @user.first.present? && @user.first.password == params[:user][:password]
  #     session[:username] = @user.first.username
  #     flash[:info] = 'You successfull authorize!'
  #     redirect '/'
  #   else
  #     flash[:warning] = 'Your username or password incorrect!'
  #     redirect '/sign_in'
  #   end
  # end
  #
  # post '/logout' do
  #   session.clear
  #   redirect '/sign_in'
  # end
end
