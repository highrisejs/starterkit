log = require('util').log

mongoose = require('mongoose')
passportLocalMongoose = require('passport-local-mongoose')

log '[TODO] adjust your user model and remove this warning!'
schema = new mongoose.Schema(
  isActive:
    type: Boolean
    default: true

  name: String
  email: String
  profile:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Profile'
  prospects: [
    type: mongoose.Schema.Types.ObjectId
    ref: 'Prospect'
  ]
)
schema.plugin passportLocalMongoose,
  usernameField: 'email'
module.exports = mongoose.model('User', schema)
