Router = require('express').Router

controllers = require('./controllers')

router = module.exports = Router()

router.use '/api',
  Router().use '/users',
    Router()
      .get '/', controllers.users.list
