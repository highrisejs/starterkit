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
  app.use '/assets/css', less(process.cwd(),
    preprocess:
      path: (pathname, req) ->
        match = req.url.match(/^\/([^\/]+)\/(.+)$/)
        return pathname unless match
        try
          pathname = require.resolve(match[1]).split('/')
          pathname =
            if pathname[-2..-1][0] is 'lib'
              pathname[0..-3].join('/')
            else
              pathname[0..-2].join('/')
        catch e
          return pathname
        path = "#{pathname}/styles/#{match[2]}"
        path = path.replace(/\.css$/, '.less')
        path
    dest: 'public/css'
    parser:
      paths: [
        'styles'
        '.'
        'public/components'
      ]
  )

  app.on 'mount', (parent) ->

    ###
    Load a browserify middleware for each application while booting.
    ###
    for a in parent.get('apps')
      p = require.resolve(a)
      try
        p = p.split('/')
        p = p[0..-2].join('/')
      catch e
        continue
      continue unless require('fs').existsSync("#{p}/client")
      app.use "/assets/js/#{a}", (req, res, done) ->
        req.url = req.url.replace(/\.js$/, '.coffee')
        done()
      app.use "/assets/js/#{a}", browserify("#{p}/client",
        transform: ['coffeeify', 'jadeify']
        extensions: ['.coffee']
        grep: /\.(?:coffee)$/
      )

    app.use '/assets', serve("#{process.cwd()}/public")

  app
