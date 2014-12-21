passport = require('passport')

exports.show = (req, res, done) ->
  fail = if req.query.fail then true else false
  res.render 'auth',
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
