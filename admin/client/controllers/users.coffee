request = require('superagent')

exports.list = ->
  users = new @models.Users()
  users.fetch
    success: =>
      React.renderComponent(
        @App url: 'users',
          @views.UsersList(users: users)
        document.getElementById('app')
      )
