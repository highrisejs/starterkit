async = require('async')
mongoose = require('mongoose')

Resource = require('express-resource-architect')

User = mongoose.model('User')
m = Resource.middleware(User)

exports.new = [
  m.new()
  m.view 'register'
]

exports.create = [
  (req, res, done) ->
    User.findOne {email: req.body.email, hash: $exists: false}, (err, user) ->
      return next(err) if err
      return done() unless user
      res.locals.user = user
      user.name = req.body.name
      user.password = req.body.password
      user.passwordConfirmation = req.body.passwordConfirmation
      done()

  m.save()

  (req, res, done) ->
    unless res.locals.user
      req.flash 'danger', "This email isn't authorized!"
      return res.redirect('/register')
    return res.render('register') if res.locals.user.errors
    req.flash 'success', '''The registration was successful! Now login using
      your chosen credentials.'''
    done()

  m.redirect '/auth'
]
