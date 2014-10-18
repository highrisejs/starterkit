express = require('express')

app = module.exports = express()
app.set 'views', "#{__dirname}/views"

app.get '/', (req, res) ->
  res.render 'index'
