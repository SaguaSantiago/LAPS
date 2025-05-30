require 'sinatra/base'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development 
require 'sinatra/activerecord'
require 'yaml'
require 'logger'
require 'dotenv/load'
require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/account'
# require_relative 'models/offer'
# require_relative 'models/validity'
require_relative 'models/transaction'
require_relative 'models/loan'
require_relative 'models/quota'


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
  
  get '/' do
    erb :home, layout: :dashboardLayout 
  end

  get '/login' do
    erb :login
  end


  get '/transference' do 
    erb :transference, layout: :sectionLayout
  end
  
  get '/signup' do
    @inputs = [
    { label: "DNI", type: "text", name: "dni", placeholder: "#######", required: true },
    { label: "Usuario", type: "text", name: "user", placeholder: "User123", required: true },
    { label: "Telefono", type: "number", name: "phone", placeholder: "", required: true },
    { label: "Email", type: "email", name: "email", placeholder: "example@example.com", required: true },
    { label: "Contraseña", type: "password", name: "password", placeholder: "********", required: true }
  ]

    erb :signup
  end
end
