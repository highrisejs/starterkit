express = require('express')

controllers = require('./controllers')

app = module.exports = express()

app.get '/', (req, res) ->
  res.render 'index'

app.route '/register'
  .get controllers.users.new
  .post controllers.users.create

app.route '/auth'
  .get controllers.sessions.new
  .post controllers.sessions.create

app.get '/logout', controllers.sessions.destroy
app.all '*', (req, res) -> res.status(404).render '404'
