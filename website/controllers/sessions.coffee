passport = require('passport')

exports.new = (req, res, done) ->
  fail = if req.query.fail then true else false
  if fail
    req.flash 'danger', 'The authorization wasn\'t successful!'
  delete req.session.registered
  res.render 'auth'

exports.create = (req, res, done) ->
  middleware = passport.authenticate('local',
    successRedirect: "#{req.baseUrl}/"
    failureRedirect: "#{req.baseUrl}/auth?fail=1"
  )
  middleware req, res, done

exports.destroy = (req, res, done) ->
  req.logout()
  res.redirect "#{req.baseUrl}/auth"
