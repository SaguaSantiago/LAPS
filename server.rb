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

# Modelos
require_relative 'models/user'
require_relative 'models/account'
require_relative 'models/transaction'
require_relative 'models/loan'
require_relative 'models/transfer'
require_relative 'models/quota'
require_relative 'models/event'
require_relative 'models/eventDate'
require_relative 'models/eventSchedule'
require_relative 'models/category'
require_relative 'models/transfer'
require_relative 'models/validity'

class App < Sinatra::Application
  configure :development do 
    enable :logging
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
    register Sinatra::Reloader
    after_reload { puts 'Reloaded...' }
    ActiveRecord::Base.connection.execute('PRAGMA foreign_keys = ON')
  end

  set :views, File.expand_path('../views', __FILE__)
  set :public_folder, File.expand_path('../public', __FILE__)
  enable :sessions

  set :database, { adapter: "sqlite3", database: "db/development.sqlite3" }

  helpers do

    def user_categories
      account = current_user.account
      one_year_ago = Date.today << 12
      categories = Category.where(account_id: account.id).distinct

      total_transactions = account.transactions.where('created_at >= ?', one_year_ago).count
      total_events = Event.joins(:event_dates)
                          .where(account_id: account.id)
                          .where(event_dates: { date: one_year_ago..Date.today })
                          .distinct.count
      total = total_transactions + total_events

      @categories = categories.map do |category|
        tx_count = category.transactions.where('created_at >= ?', one_year_ago).count
        event_count = category.events
                              .joins(:event_dates)
                              .where(event_dates: { date: one_year_ago..Date.today })
                              .distinct.count
        percentage = total > 0 ? ((tx_count + event_count).to_f / total * 100).round(2) : 0

        {
          name: category.name,
          color: category.color,
          percentage: percentage
        }
      end
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def require_login
      redirect '/login' unless current_user
    end
  end
  helpers do
    def current_account
      @current_account ||= Account.find_by(user_id: session[:user_id])
    end
  end
  


  get '/' do
    redirect '/login' unless logged_in?
    user_categories
    current_user
    @last_transactions = Transaction
    .includes(:category, :source_account, :target_account)
    .where("source_account_id = :id OR target_account_id = :id", id: current_user.account.id)
    .order(created_at: :desc)
    .limit(5)
    erb :home, layout: :dashboardLayout 
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/'
    else 
      @error = "Usuario o contraseña incorrecta"
      erb :login
    end
  end

  post '/logout' do
    session.clear
    redirect '/login'
  end

  get '/signup' do
    erb :signup
  end

  get '/transference' do
    require_login
    @sectionName = { label: "Crear Categoría" }
    erb :transference, layout: :sectionLayout
  end

  get '/cbuTransference' do
    require_login
    account = current_user.account
    @categories = Category.where(account_id: account.id).distinct
    @sectionName = { label: "Transferir con CBU, CVU o Alias" }
    erb :cbuTransference, layout: :sectionLayout
  end

  post '/cbuTransference' do
    require_login
    
    account = current_user.account
    @categories = Category.where(account_id: account.id).distinct
    target_account =  Account.find_by(cvu: params[:cbu]) ||
                      Account.find_by(alias: params[:cbu])
                      
    if !target_account
      @errors = ["Cuenta destino no encontrada."]
      @sectionName = { label: "Transferir con CBU, CVU o Alias" }
      return erb :cbuTransference, layout: :sectionLayout
    end
    
    category = Category.find_by(id: params[:category_id])

    if !category
      @errors = ["Debe seleccionar una categoría válida."]
      @sectionName = { label: "Transferir con CBU, CVU o Alias" }
      return erb :cbuTransference, layout: :sectionLayout
    end

    transference = Transfer.new(
      source_account: account,
      target_account: target_account,
      amount: params[:amount].to_f,
      category: category
    )


    if transference.save
      redirect '/transference'
    else
      @errors = transference.errors.full_messages
      @sectionName = { label: "Transferir con CBU, CVU o Alias" }
      @categories = Category.where(account_id: account.id).distinct
      erb :cbuTransference, layout: :sectionLayout
    end
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
      @categories = Category.where(account_id: account.id).order(:name)
      @errors = user.errors.full_messages
      erb :signup
    end
  end

  get '/categories' do 
    require_login
    @sectionName = { label: "Categorías" }
    account = current_user.account
    @categories = Category.where(account_id: current_user.account.id).distinct
    erb :categories, layout: :sectionLayout
  end

  get '/newCategory' do
    require_login
    @sectionName = { label: "Crear Categoría" }
    erb :newCategory, layout: :sectionLayout
  end

  post '/newCategory' do
    require_login
    account = current_user.account
    category = Category.new(
      name: params[:Titulo],
      description: params[:Descripcion],
      color: params[:color],
      account_id: account.id
    )

    if category.save
      redirect '/categories'
    else
      @errors = category.errors.full_messages
      @sectionName = { label: "Crear Categoría" }
      erb :newCategory, layout: :sectionLayout
    end
  end

  get '/create-event' do
    require_login
    @sectionName = { label: "Crear Evento" }
    @categories = Category.where(account_id: current_user.account.id).distinct
    erb :createEvent, layout: :sectionLayout
  end

  post '/create-event' do
    require_login
    account = current_user.account
    event = Event.new(
      title: params[:title],
      description: params[:description],
      period: params[:period],
      category_id: params[:category_id],
      account_id: account.id
    )

     event.instance_variable_set(:@start_date, Date.parse(params[:date])) if params[:date]

    if event.save
      status 201
      redirect '/calendar'
    else
      @errors = event.errors.full_messages
      @sectionName = { label: "Crear Evento" }
      erb :createEvent, layout: :sectionLayout
    end
  end

  helpers do
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def logged_in?
      !!current_user
    end
  end


  get '/calendar' do
    require_login
    user = current_user
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

    if params[:filter] == 'historial'
      start_of_month = Date.new(@dateToShow.year, @dateToShow.month, 1)
      end_of_month = Date.new(@dateToShow.year, @dateToShow.month, -1)

      @transactions = Transaction
                        .includes(:category)
                        .where(account_id: account.id)
                        .where(created_at: start_of_month..end_of_month)
    erb :calendar, layout: :sectionLayout
    else
      @events = Event.includes(:category).joins(:event_dates)
                    .where(account_id: account)
                    .where(event_dates: { date: @firstDay..@lastDay })
                    .distinct
    erb :calendar, layout: :sectionLayout
    end
  end

  get '/admin-gastos' do
    require_login
    account = current_user.account
    @sectionName = { label: "admin-gastos" }

    one_year_ago = Date.today << 12
    categories = Category.where(account_id: account.id).distinct

    total_transactions = account.transactions.where('created_at >= ?', one_year_ago).count
    total_events = Event.joins(:event_dates)
                        .where(account_id: account.id)
                        .where(event_dates: { date: one_year_ago..Date.today })
                        .distinct.count
    total = total_transactions + total_events

    @categories = categories.map do |category|
      tx_count = category.transactions.where('created_at >= ?', one_year_ago).count
      event_count = category.events
                             .joins(:event_dates)
                             .where(event_dates: { date: one_year_ago..Date.today })
                             .distinct.count
      percentage = total > 0 ? ((tx_count + event_count).to_f / total * 100).round(2) : 0

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
    require_login
    account = current_user.account
    @sectionName = { label: "Sacar Prestamos" }
    @categories = Category.where(account_id: account.id).distinct
    erb :loan, layout: :sectionLayout
  end

  get '/transactions' do
    require_login
    account = current_user.account
    @transactions = account ? account.transactions.order(created_at: :desc) : []
    @sectionName = { label: "Últimos movimientos" }
    erb :transactions, layout: :sectionLayout
  end

  get '/transactions/:id' do
    @transaction = Transaction.find_by(id: params[:id])
    if @transaction
      @sectionName = { label: "Detalle de operación" }       
      erb :show, layout: :sectionLayout
    else
      @sectionName = { label: "Error: Transacción no encontrada" }
      status 404
      erb :not_found, layout: :sectionLayout
    end
  end

  post '/' do
    redirect '/login' unless logged_in?

    cantidad = params[:cantidad].to_f

    if cantidad != 0
      current_user.account.actualizar_balance(cantidad)
      redirect '/'
    else
      @error = "Debes ingresar una cantidad válida."
      erb :home
    end
  end
  post '/loan' do
    redirect '/login' unless session[:user_id]
  
    user          = User.find(session[:user_id])
    account       = user.account
    amount        = params[:amount].to_f
    installments  = params[:installments].to_i
  
    @sectionName  = { label: "Sacar Préstamos" }
  
    if amount <= 0 || ![1,3,6,12].include?(installments)
      @error = "Monto o cantidad de cuotas inválido."
      return erb :loan, layout: :sectionLayout
    end

    loan = Loan.new(
        account_id: account.id, # MUY IMPORTANTE
        amount: amount,
        quotas_number: installments,
        expiration_period: Date.today >> installments,
        source_account_id: account.id,
        target_account_id: account.id,
      
    )
    
  
    if loan.save
  
      @success = "¡Préstamo de $#{amount} otorgado en #{installments} cuota(s)!"
    else
      @error = "No se pudo procesar el préstamo."
    end
  
    erb :loan, layout: :sectionLayout
  end
  
end
