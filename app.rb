require 'sinatra'
require 'sqlite3'
require 'bcrypt'
require 'sinatra/activerecord'
require './models/user'


#recordar quien esta logueado
enable :sessions

#conexion a la base de datos
set :database, { adapter: "sqlite3", database: "db/development.sqlite3" }

# Ruta GET: muestra el formulario de registro
get '/signup' do
    erb :signup #/views
end

post '/signup' do
    user = User.new(
        dni: params[:dni],
        username: params[:user], 
        phone: params[:phone],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
    )

    if user.save
        redirect '/login'
    else 
        #@errors = user.errors.full_messages #añadir error en la vista
        @error = "Campos incompletos"
        erb :register
    end
end

#Ruta GET: muestra el formulario de inicio de sesion.
get '/login' do
    erb :login #views
end

post '/login' do
    user = User.find_by(username: params[:user])

    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/welcome'
    else 
        @error = "usuario o contraseña incorrecta"
        erb :login
    end
end

get '/logout' do
    session.clear
    redirect '/login'
end