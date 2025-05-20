# Esta línea indica la versión de Ruby que se espera o se recomienda para este proyecto.
# En este caso, es la versión 3.2.2. Aunque esta es una convención común,
ruby '3.2.2'

# Esta línea es fundamental en cualquier Gemfile.
# Indica el origen de donde Bundler (la herramienta que lee y procesa el Gemfile)
source "https://rubygems.org"

# Declara las dependencias del proyecto (gemas requeridas).
# Cada línea con `gem` especifica una gema y, opcionalmente, su versión o restricciones.

# Gema: sinatra
# Sinatra es un framework ligero para construir aplicaciones web en Ruby.
# La restricción '~> 4.1' indica que se usará la versión 4.1.x (cualquier versión 4.1 con parches, pero no 4.2 o superior).
# Esto garantiza compatibilidad con las funcionalidades esperadas sin introducir cambios mayores imprevistos.
gem 'sinatra', '~> 4.1'

# Gema: rackup
# `rackup` es una herramienta de línea de comandos incluida en la gema `rack`.
# Se usa para iniciar servidores web compatibles con Rack, como el servidor de Sinatra.
# Al incluir esta gema, aseguramos que el comando `rackup` esté disponible para ejecutar el archivo `config.ru`.
# Nota: No se especifica una versión, por lo que Bundler usará la última versión estable disponible.
gem 'rackup'

# Gema: puma
# Puma es un servidor web concurrente y de alto rendimiento para aplicaciones Ruby/Rack.
# Es comúnmente usado con Sinatra por su velocidad y capacidad para manejar múltiples solicitudes simultáneamente.
gem 'puma', '~> 6.6'

# Incluye la gema sinatra-contrib, que proporciona extensiones útiles para Sinatra, como recarga automática (reloader), helpers y herramientas de desarrollo.
gem 'sinatra-contrib'

# Gema: sinatra-activerecord
# Integra ActiveRecord (un ORM de Ruby) con Sinatra.
# Permite usar modelos y manejar bases de datos relacionales fácilmente
gem 'sinatra-activerecord'

# Gema: sqlite3
# Proporciona una interfaz para usar SQLite, una base de datos ligera y sin servidor.
# Es ideal para desarrollo o aplicaciones pequeñas, ya que almacena datos en un solo archivo.
gem 'sqlite3'

# Gema: rake
# Herramienta para automatizar tareas en Ruby (similar a Make).
# En este contexto, se usa para ejecutar tareas de base de datos, como migraciones con ActiveRecord (ej. `rake db:migrate`).
gem 'rake'

# Gema: dotenv
# Permite cargar variables de entorno desde un archivo `.env` en el directorio raíz del proyecto.
# se utilizara para gestionar el entorno
gem 'dotenv'