React = require('react')

module.exports = ->
  React.renderComponent(
    @App url: 'dashboard',
      @views.Dashboard()
    document.getElementById('app')
  )
