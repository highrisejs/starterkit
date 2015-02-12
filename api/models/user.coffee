log = require('util').log

mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

log '[TODO] adjust your user model and remove this warning!'
schema = new mongoose.Schema(
  isActive:
    type: Boolean
    default: true

  name:
    type: String
    required: true

  email:
    type: String
    required: true
)

schema.virtual('password')
  .get -> @_password
  .set (v) -> @_password = v
schema.virtual('passwordConfirmation')
  .get -> @_passwordConfirmation
  .set (v) -> @_passwordConfirmation = v

schema.plugin passportLocalMongoose,
  usernameField: 'email'

schema.path('salt').validate ->
  if @password isnt @passwordConfirmation
    @invalidate 'passwordConfirmation', 'Passwords don\'t match!'

schema.pre 'validate', (done) ->
  if @isNew and not @password
    @invalidate 'password', 'Password is required!'
    return done()
  if @password
    @setPassword @password, (err) ->
      return done(err) if err
      done()
  else
    done()

module.exports = mongoose.model('User', schema)
