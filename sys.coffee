express = require('express')
routes = require('./routes')
mongoose = require('mongoose')
fs = require('fs')
require('./db-connect')
require('connect-mongodb')

GLOBAL.app = module.exports = express.createServer()
io = require('socket.io').listen(app)

#bootstrap models
models_path = __dirname + '/models'
model_files = fs.readdirSync(models_path)

model_files.forEach (file) ->
  require models_path + "/" + file

#Configuration
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")
  app.use (req, res) ->
    res.status 404
    res.render "404.jade",
      title: "404"

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

# Routes
Post = mongoose.model("Post")
User = mongoose.model("User")


app.get "/", (req, res) ->
  Post.find().sort(created_at: -1).execFind (err, posts) ->
    throw err  if err
    res.render "index",
      title: "Articles"
      posts: posts

app.get "/users", (req, res) ->
  User.find().sort(name: -1).execFind (err, users) ->
    throw err  if err
    res.render "users",
      title: "Users"
      users: users

#New post
app.get "/posts/new", (req, res) ->
  res.render "posts/new",
    title: "New article"

#New user
app.get "/reg", (req, res) ->
  res.render "reg",
    title: "Registration"
    errors: ""


#POST
app.post "/posts", (req, res) ->
  post = new Post()
  post.title = req.body.title
  post.body = req.body.body
  post.save (err) ->
    if err
      res.render "posts/new",
        title: "error"
    else
      io.sockets.emit "new_post", post
      res.redirect "/"

app.post "/reg", (req, res) ->
  user = new User()
  user.name = req.body.name
  user.email = req.body.email
  user.password = req.body.password
  user.save (err) ->
    console.log err
    if err
      res.render "reg",
        title: "Registration"
        errors: err
    else
      #			io.sockets.emit('new_user', user);
      res.redirect "/"

app.listen 3000, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env