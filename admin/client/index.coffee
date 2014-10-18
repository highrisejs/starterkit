React = window.React = require('react')
page = require('page')
Backbone = window.Backbone = require('backbone')
Backbone.$ = jQuery

views = require('./views')
controllers = require('./controllers')

# Expose React for developer tools.
Messenger.options =
  theme: 'flat'
Messenger().hookBackboneAjax
  errorMessage: 'Error syncing with the server!'

Router = Backbone.Router.extend(
  initialize: ->
    @models = require('./models')
    @views = require('./views')
    @App = require('./app')
  routes:
    'dashboard': controllers.dashboard
    'users': controllers.users.list
)

router = new Router()
Backbone.history.start()
