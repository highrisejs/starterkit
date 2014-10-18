React = require('react')

module.exports = React.createClass(
  render: ->
    R = React.DOM

    R.div {},
      R.h2 {}, 'Dashboard',
        R.small {}, ' Stats and stuff'
      R.div className: 'row',
        R.div className: 'col-md-6',
          R.div className: 'panel panel-default',
            R.div className: 'panel-heading',
              R.h4 className: 'panel-title', 'Graphs'
            R.div className: 'panel-body',
              'Show some cool graphs and stuff here.'
        R.div className: 'col-md-6',
          R.div className: 'panel panel-default',
            R.div className: 'panel-heading',
              R.h4 className: 'panel-title',
                'Some other stuff'
            R.div className: 'panel-body',
              '...'
)
