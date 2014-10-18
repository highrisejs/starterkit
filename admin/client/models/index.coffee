Backbone = require('backbone')

exports.User = Backbone.Model.extend(
  idAttribute: '_id'
  urlRoot: '/api/users'
)

exports.Users = Backbone.Collection.extend(
  url: '/api/users'
)
