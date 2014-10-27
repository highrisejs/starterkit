
express = require('express')
mongoose = require('mongoose')
serve = require('serve-static')
cookieParser = require('cookie-parser')
session = require('express-session')
bodyParser = require('body-parser')
passport = require('passport')
RedisStore = require('connect-redis')(session)

# Load all the models of the applications.
require './api/models'

User = mongoose.model('User')

project = module.exports = express()
project.set 'view engine', 'jade'
project.set 'cookie secret', process.env.COOKIE_SECRET || 'keyboard cat'
project.set 'session store', new RedisStore(
  host: process.env.REDIS_PORT_6379_TCP_ADDR
  port: process.env.REDIS_PORT_6379_TCP_PORT
)

###
Serialize user.
###
passport.serializeUser (user, next) ->
  next null, user._id

###
Deserialize user from database.
###
passport.deserializeUser (id, next) ->
  User.findById id, (err, user) ->
    return next(err) if err
    next null, user

# Create Strategy for database user.
passport.use User.createStrategy()

project.use bodyParser.urlencoded(extended: true)
project.use cookieParser(process.env.COOKIE_SECRET || 'keyboard cat')
project.use session(
  secret: process.env.COOKIE_SECRET || 'keyboard cat'
  store: new RedisStore(
    host: process.env.REDIS_PORT_6379_TCP_ADDR
    port: process.env.REDIS_PORT_6379_TCP_PORT
  )
  saveUninitialized: true
  resave: true
)
project.use passport.initialize()
project.use passport.session()

project.use require('./website')
project.use require('./admin')
project.use require('./api')

# Serve browserify bundles.
if project.get('env') is 'development'
  project.get /^\/assets\/js\/([a-z0-9]+)\/(.+)$/, (req, res, next) ->
    middleware = require('browserify-middleware')

    # Construct the coffee source path.
    coffeePath = req.params[1].replace(/\.js$/, '.coffee')
    fn = middleware(
      "#{__dirname}/#{req.params[0]}/client/#{coffeePath}"
      transform: ['coffeeify']
      extensions: ['.coffee']
    )
    fn req, res, next

project.use '/assets', serve("#{__dirname}/public")