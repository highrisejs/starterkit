dirname = require('path').dirname
express = require('express')

module.exports = (opts = {}) ->
  project = express()

  ###
  Boot up all applications.
  ###
  project.boot = (apps) ->
    project.set 'apps', apps.map (x) ->
      if Array.isArray(x)
        x[0]
      else
        x

    for app, i in apps
      if Array.isArray(app)
        path = require.resolve(app[0])
        app = require(path).call(null, app[1..])
      else
        path = require.resolve(app)
        app = require(path)
      unless app.get('view engine')
        if app.set?
          app.set 'view engine', project.get('view engine')
      if app.set?
        app.set 'views', "#{dirname(path)}/views"
      project.use app

  project
