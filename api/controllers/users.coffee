mongoose = require('mongoose')

User = mongoose.model('User')

exports.list = [
  (req, res, next) ->
    User.find (err, users) ->
      return next(err) if err
      res.send users
]
