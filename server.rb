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
require_relative 'models/category'


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
  
  get '/categories' do 
    redirect '/login' unless session[:user_id]

    user = User.find(session[:user_id])
    account = user.account

    @sectionName = { label: "Categorías" }

    @categories = Category.where(account_id: account)
    @categories = @categories.order(:name) if @categories.any?
    erb :categories, layout: :sectionLayout
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
    @filter = params[:filter] || 'historial'
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

     @sectionName = { label: "Calendario" }

    # Buscar eventos solo en ese rango extendido
    @events = Event.joins(:event_dates)
                  .where(account_id: account)
                  .where(event_dates: { date: @firstDay..@lastDay })
                  .distinct
    erb :calendar, layout: :sectionLayout
  end

  get '/admin-gastos' do
    redirect '/login' unless session[:user_id]
    user = User.find(session[:user_id])
    account_id = user.account
    @sectionName = { label: "admin-gastos" }

    one_year_ago = Date.today << 12

    categories = Category.where(account_id: account_id).distinct
    
    total_transactions = Transaction.where(account_id: account_id).where('created_at  >= ?', one_year_ago).count
    total_events = Event.joins(:event_dates)
                    .where(account_id: account_id)
                    .where(event_dates: { date: one_year_ago..Date.today })
                    .distinct
                    .count
    total = total_transactions + total_events

    @categories = categories.map do |category|
      tx_count = category.transactions.where('created_at  >= ?', one_year_ago).count
      event_count = category.events
                      .joins(:event_dates)
                      .where(event_dates: { date: one_year_ago..Date.today })
                      .distinct
                      .count
      category_total = tx_count + event_count

      percentage = total > 0 ? ((category_total.to_f / total) * 100).round(2) : 0

      {
        id: category.id,
        name: category.name,
        color: category.color,
        percentage: percentage
      }
    end

    erb :adminGastos, layout: :sectionLayout
  end

    get '/loan' do
      redirect '/login' unless session[:user_id]
      user = User.find(session[:user_id])
      account_id = user.account
      @sectionName = 
    { label: "Sacar Prestamos"}

      @categories = Category.where(account_id: account_id).distinct

      puts @categories
      erb :loan, layout: :sectionLayout
    end 
    get '/transactions' do
      redirect '/login' unless session[:user_id]
    
      @user = User.find(session[:user_id])
      account = @user.account
    
      # traer las transacciones
      #@transactions = account.transactions.order(created_at: :desc)
      
      #@transactions = Transaction.where(account_id: account).order(created_at: :desc)
      account = @user.account
  
      if account
        @transactions = account.transactions.order(created_at: :desc)
      else
        @transactions = []  # o ActiveRecord::Relation vacío
      end
  
      @sectionName = { label: "Últimos movimientos" }
      erb :transactions, layout: :sectionLayout
    end
    get '/transactions/:id' do
      @transaction = Transaction.find(params[:id])
      erb :show, layout: :sectionLayout
    end
end
