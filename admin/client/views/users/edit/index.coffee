React = require('react')

module.exports = React.createClass(
  getInitialState: ->
    user: @props.user
  handleUserChange: (key) ->
    (e) =>
      @state.user[key] = e.target.value
      @setState @state
  render: ->
    R = React.DOM

    R.div {},
      R.h2 {},
        if @state.user._id
          "Edit #{@state.user.email or '<Unknown>'}"
        else
          'New user'
      R.div className: 'form-horizontal',
        R.div className: 'form-group',
          R.label className: 'col-sm-2 control-label', 'Name'
          R.div className: 'col-sm-5',
            R.input
              type: 'text'
              value: @state.user.name
              onChange: @handleUserChange('name')
        R.div className: 'form-group',
          R.label className: 'col-sm-2 control-label', 'E-Mail'
          R.div className: 'col-sm-5',
            R.input
              type: 'text'
              value: @state.user.email
              onChange: @handleUserChange('email')
)
