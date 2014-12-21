
express = require('express')

controllers = require('./controllers')

app = module.exports = express()

app.get '/', (req, res) ->
  res.render 'index'

app.get '/register', controllers.register
app.post '/register', controllers.users.create
app.route '/auth'
  .get controllers.auth.show
  .post controllers.auth.create
app.get '/logout', controllers.auth.destroy
app.all '*', (req, res) -> res.status(404).render '404'
