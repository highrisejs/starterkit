React = require('react')

DataTable = require('data_table_component')

module.exports = React.createClass(
  handleDestroy: (user) ->
    =>
      msg = Messenger().post
        message: 'Are you sure to delete this user?'
        actions:
          destroy:
            label: 'Delete'
            action: ->
              msg.update(
                type: 'success'
                message: 'Destroyed'
                actions: {}
                hideAfter: 2
              )
          cancel:
            action: -> msg.hide()
  render: ->
    R = React.DOM

    R.div {},
      DataTable {},
        R.table className: 'table',
          R.thead {},
            R.th {}, 'Name'
            R.th {}, 'E-Mail'
            R.th {}, 'Aktionen'
          R.tbody {},
            for user in @props.users or []
              R.tr key: user._id,
                R.td {}, user.name
                R.td {}, user.email
                R.td {},
                  R.button
                    className: 'btn btn-default btn-sm'
                  ,
                    R.i className: 'fa fa-edit'
                  R.button
                    className: 'btn btn-default btn-sm'
                    onClick: @handleDestroy(user)
                  ,
                    R.i className: 'fa fa-trash-o'
)
