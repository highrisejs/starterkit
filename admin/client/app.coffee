module.exports = React.createClass(
  getInitialState: ->
    R = React.DOM
    content: R.div {}

  render: ->
    R = React.DOM

    R.div className: 'container',
      R.div className: 'row',
        R.div className: 'col-md-3',
          R.div className: 'list-group',
            R.a
              className: 'list-group-item' + if @props.url is 'dashboard'
                ' active'
              else
                ''
              href: '/admin/#dashboard', 'Dashboard'
            R.a
              className: 'list-group-item' + if @props.url is 'users'
                ' active'
              else
                ''
              href: '/admin/#users', 'Users'
        R.div className: 'col-md-9',
          @props.children
)
