# 💸 LAPS - Wallet

**LAPS** es una billetera virtual enfocada en la visualización del flujo de tu dinero. Su objetivo es brindarte herramientas útiles para organizar tus finanzas personales, facilitando el seguimiento de ingresos, egresos, eventos recurrentes y categorías de gasto.

---

## 🛠 Tecnologías utilizadas

- **Ruby 3.2.2**
- **Sinatra** 4.1 – Framework web liviano
- **ActiveRecord** – ORM para manejo de base de datos
- **SQLite3** – Base de datos embebida
- **Puma** – Servidor web de alto rendimiento
- **BCrypt** – Hash seguro para contraseñas
- **Dotenv** – Carga de variables de entorno
- **Rackup** – Configuración de entorno y despliegue
- **Sinatra-Contrib** – Recarga automática, helpers, etc.
- **Rake** – Automatización de tareas

---

## ⚙️ Cómo correr el proyecto localmente

1. **Clonar el repositorio**

```bash
git clone https://github.com/tuusuario/laps-wallet.git
cd laps-wallet
```

2. **Instalar dependencias**

```bash
bundle install
```

3. **Configurar la base de datos**

```bash
bundle exec rake db:create
bundle exec rake db:migrate
```

4. **Levantar el servidor**

```bash
bundle exec rackup -p 8000
```

Luego accedé desde: [http://localhost:8000](http://localhost:8000)

---

## 📁 Estructura del proyecto

```
.
├── .ruby-lsp/                 # Archivos del entorno Ruby Language Server
├── config/                    # Configuraciones adicionales o del entorno
├── db/
│   └── migrate/               # Migraciones de ActiveRecord
├── models/                    # Modelos de datos (User, Account, Transaction, etc.)
├── public/
│   └── images/               # Imágenes y archivos estáticos
├── views/                     # Vistas ERB para la interfaz de usuario
├── server.rb                  # Archivo principal de la aplicación
├── Gemfile                    # Declaración de dependencias
└── .env                       # Variables de entorno (no versionado)
```

---

## 🧩 Funcionalidades principales

- ✅ **Registro e inicio de sesión** con cifrado seguro de contraseñas.
- ✅ **Gestión de categorías** de ingreso/gasto personalizadas por cuenta.
- ✅ **Registro de transacciones** con categorías, fechas y descripción.
- ✅ **Visualización de últimos movimientos**.
- ✅ **Eventos financieros periódicos** (como alquiler, cuotas, etc.).
- ✅ **Calendario mensual** con eventos y movimientos históricos.
- ✅ **Análisis de gastos por categoría** del último año (porcentaje visual).
- ✅ **Carga inicial de dinero a cuenta**.
- ✅ **Préstamos** con categorías asociadas.
- 🔐 Acceso protegido por sesión y control de permisos.

---

## 🧪 Modelos principales

- `User`: Autenticación y datos del usuario
- `Account`: Información financiera personal, balance
- `Transaction`: Movimiento de dinero (ingreso o egreso)
- `Event`: Eventos recurrentes con fecha y categoría
- `Category`: Clasificación de transacciones/eventos
- `Loan`, `Quota`: Módulo para préstamos
- `EventDate`, `EventSchedule`: Control de repetición en calendario

---

## 📌 Notas adicionales

- El archivo `server.rb` contiene toda la lógica de ruteo y helpers.
- Los datos se actualizan automáticamente con el uso de relaciones `ActiveRecord`.

---

## 🤝 Colaboradores

Este proyecto fue desarrollado como parte de un equipo de 4 personas con foco en prácticas de buenas migraciones, trabajo colaborativo y enfoque MVC con Sinatra.

---
