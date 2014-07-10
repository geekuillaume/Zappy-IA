 #!/usr/bin/env coffee

argv = require('optimist').usage "IA for the zappy server"
    .demand "n"
    .alias "n", "team"
    .describe "n", "Nom de l'équipe"
    .demand "p"
    .alias "p", "port"
    .describe "p", "Port du server"
    .demand "h"
    .alias "h", "host"
    .describe "h", "Hostname du server"
    .argv
client = require './libs/zappy-client.coffee'
player = require './libs/zappy-player.coffee'
ia = require './libs/zappy-ia.coffee'

player.client = client

config =
    team: argv.team
    port: argv.port
    host: argv.host

client.connect(config).then ->
    console.log "Connected to", config.host, ":", config.port
    client.send config.team
.then (message) ->
    if message == "ko"
        throw new Error "Wrong team name"
    player.seatLeft = parseInt message
    client.next()
.then (message) ->
    player.initMap (parseInt message.split(" ")[0]), (parseInt message.split(" ")[1])
    ia.start player
.done()
