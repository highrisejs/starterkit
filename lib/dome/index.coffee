dirname = require('path').dirname

exports = module.exports = (project, opts = {}) ->
  opts.apps = [] unless opts.apps
  project.set 'apps', opts.apps.map (x) ->
    if Array.isArray(x)
      x[0]
    else
      x

  project.use (req, res, next) ->

    # Set template rootpath.
    res.locals.basedir = process.cwd()
    res.locals.req = req
    next()

  exports.assets.call(project)
  for app, i in opts.apps
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

exports.assets = require('./assets')
