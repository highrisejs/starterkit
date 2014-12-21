async = require('async')
mongoose = require('mongoose')

User = mongoose.model('User')

exports.create = (req, res, done) ->
  async.waterfall([
    (next) ->
      User.findOne {email: req.body.email, hash: $exists: false}, (err, user) ->
        return next(err) if err
        return done() unless user
        next null, user

    (user, next) ->
      user.remove (err) ->
        return next(err) if err
        password = req.body.password
        delete req.body.password
        User.register req.body, password, (err, user) ->
          return next(err) if err
          next null, user
  ], (err) ->
    return done(err) if err
    req.flash 'success', 'Account successfully registered!'
    res.redirect "#{req.baseUrl}/auth"
  )
