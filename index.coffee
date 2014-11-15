
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

if process.env.REDISCLOUD_URL
  redisUrl = require('url').parse(process.env.REDISCLOUD_URL)
  redisAuth = redisUrl.auth.split(':')
  project.set 'session store options',
    host: redisUrl.hostname
    port: redisUrl.port
    pass: redisAuth[1]
else
  project.set 'session store options',
    host: process.env.REDIS_PORT_6379_TCP_ADDR
    port: process.env.REDIS_PORT_6379_TCP_PORT

project.set 'session store', new RedisStore(
  project.get 'session store options'
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
  store: project.get('session store')
  saveUninitialized: true
  resave: true
)
project.use passport.initialize()
project.use passport.session()

project.use require('method-override')('_method')

project.use (req, res, next) ->

  # Set template rootpath.
  res.locals.basedir = "#{__dirname}"
  res.locals.req = req
  next()

###
Make the project only accessible by authorized demo users.
###
if project.get('env') is 'production'
  project.all /^\/([^\/]*)\/?.*/, (req, res, done) ->
    return done() if req.params[0] in ['assets', 'auth', 'register']
    return res.redirect(307, '/auth') unless req.isAuthenticated()
    done()

# Serve browserify bundles.
if project.get('env') is 'development'
  less = require('less-middleware')
  project.use '/assets/css', less(__dirname,
    preprocess:
      path: (pathname, req) ->
        match = req.url.match(/^\/([^\/]+)\/(.+)$/)
        return pathname unless match
        path = "#{__dirname}/#{match[1]}/styles/#{match[2]}"
        path.replace(/\.css$/, '.less')
    dest: 'public/css'
    parser:
      paths: [
        'styles'
        'lib'
        'public/components'
      ]
  )
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

# Catchall.
project.use require('./website')
