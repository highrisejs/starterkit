React = require('react')

module.exports = React.createClass(
  componentDidMount: ->
    opts = {}
    for own key, value of @props
      continue if key is 'children'
      opts[key] = value
    $(@getDOMNode()).dataTable opts
  render: ->
    @props.children
)
