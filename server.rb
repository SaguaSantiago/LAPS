require 'sinatra/base'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development 
require 'sinatra/activerecord'
require 'yaml'
require 'logger'
require 'dotenv/load'
require 'sinatra'
require 'sqlite3'
require 'bcrypt'
require_relative 'models/user'
require_relative 'models/account'
# require_relative 'models/offer'
# require_relative 'models/validity'
require_relative 'models/transaction'
require_relative 'models/loan'
require_relative 'models/quota'
require_relative 'models/event'
require_relative 'models/eventDate'
require_relative 'models/eventSchedule'


class App < Sinatra::Application
    configure :development do 
        enable :logging
        logger = Logger.new(STDOUT)
        logger.level = Logger::DEBUG if development?
        set :logger, logger
        # set :database_file, 'config/database.yml'
        
        register Sinatra::Reloader
        after_reload do 
            puts 'Reloaded...'
        end
        ActiveRecord::Base.connection.execute('PRAGMA foreign_keys = ON')
  end
  
  set :views, File.expand_path('../views', __FILE__)
  set :public_folder, File.expand_path('../public', __FILE__)
  #recordar quien esta logueado
  enable :sessions

  #conexion a la base de datos
  set :database, { adapter: "sqlite3", database: "db/development.sqlite3" }
  
  get '/' do
    erb :home, layout: :dashboardLayout 
  end

  get '/login' do
    erb :login
  end


  get '/transference' do 
    @sectionName = 
    { label: "Transferir Dinero"}
    erb :transference, layout: :sectionLayout
  end
  
  get '/signup' do
    erb :signup
  end

  post '/signup' do
    user = User.new(
        dni: params[:dni],
        cuit: params[:cuit],
        username: params[:username], 
        phone: params[:phone],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
    )

    if user.save
        redirect '/login'
    else 
        @errors = user.errors.full_messages #añadir error en la vista
        erb :signup
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/'
    else 
        @error = "usuario o contraseña incorrecta"
        erb :login
    end
  end

  post '/logout' do
    session.clear
    redirect '/login'
  end

  get '/calendar' do
    redirect '/login' unless session[:user_id]
    backDays = [6,0,1,2,3,4,5]
    user = User.find(session[:user_id])
    account = user.account

    delta = (params[:delta] || 0).to_i
    @today = Date.today
    @dateToShow = Date.today >> delta

    first_of_month = Date.new(@dateToShow.year, @dateToShow.month, 1)

    days_to_monday = (first_of_month.wday - 1) % 7
    @firstDay = first_of_month - days_to_monday

    last_of_month = Date.new(@dateToShow.year, @dateToShow.month, -1)

    days_to_sunday = (7 - last_of_month.wday) % 7
    @lastDay = last_of_month + days_to_sunday

    # Buscar eventos solo en ese rango extendido
    @events = Event.joins(:event_dates)
                  .where(account_id: account)
                  .where(event_dates: { date: @firstDay..@lastDay })
                  .distinct
    erb :calendar, layout: :sectionLayout
  end
end
