express = require('express')
less = require('less-middleware')
browserify = require('browserify-middleware')
serve = require('serve-static')

module.exports = ->
  app = express()

  ###
  Initialize the less middleware to compile our css assets on the
  fly.
  ###
  app.use '/assets', less(process.cwd(),
    dest: 'public'
    parser:
      paths: [
        'styles'
        '.'
        'public/components'
      ]
  )

  app.use '/assets', browserify(process.cwd(),
    transform: ['coffeeify', 'jadeify']
    extensions: ['.coffee']
    grep: /^\/[a-z0-9_]+\/client\/[a-z0-9_]+\.(?:coffee)$/
  )

  app.use '/assets', serve("#{process.cwd()}/public")

  app
