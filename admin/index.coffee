express = require('express')

# Starter point for the administration interface of the project.

app = module.exports = express()
app.set 'views', "#{__dirname}/views"

app.get '/admin/*', (req, res) ->
  res.render 'index'

app.get '/admin', (req, res) ->
  res.redirect '/admin/', 307
