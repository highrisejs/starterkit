passport = require('passport')

exports.show = (req, res, done) ->
  registered = if req.session.registered then true else false
  fail = if req.query.fail then true else false
  delete req.session.registered
  res.render 'auth',
    registered: registered
    fail: fail

exports.create = (req, res, done) ->
  middleware = passport.authenticate('local',
    successRedirect: "#{req.baseUrl}/"
    failureRedirect: "#{req.baseUrl}/auth?fail=1"
  )
  middleware req, res, done

exports.destroy = (req, res, done) ->
  req.logout()
  res.redirect "#{req.baseUrl}/auth"
