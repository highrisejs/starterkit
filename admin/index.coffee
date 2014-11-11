express = require('express')

# Starter point for the administration interface of the project.

app = module.exports = express()
app.locals.components = require('./components')
app.set 'views', "#{__dirname}/views"

app.get '/admin/*', (req, res) ->
  res.render 'index',
    product: {}

app.get '/admin', (req, res) ->
  res.redirect '/admin/', 307
