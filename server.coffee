log = require('util').log
http = require('http')

mongoose = require('mongoose')

mongooseConnected = false
mongooseUrl = process.env.MONGOHQ_URL

unless mongooseUrl
    log '[TODO] adjust your database and remove this warning!'

    # Construct connection url from docker environment variables.
    mongooseUrl = """mongodb://#{process.env.MONGO_PORT_27017_TCP_ADDR}:\
      #{process.env.MONGO_PORT_27017_TCP_PORT}/starterkit"""

server = http
  .createServer (req, res) ->
    run = =>
      require('./index').call this, req, res

    # Boot the application directly if mongoose is already connected.
    return run() if mongooseConnected

    # Attempt to connect.
    mongoose.connect mongooseUrl, (err) ->
      return res.end('Failed to connect to database!') if err
      app = require('./index')
      mongooseConnected = true
      app.set 'server', server
      run()

  # Listen on port 3000 which is brought outside of docker.
  .listen 3000, ->
    log 'server listening'
