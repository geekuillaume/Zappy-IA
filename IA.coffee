 #!/usr/bin/env coffee

config = require './config.json'
client = require './libs/zappy-client.coffee'
player = require './libs/zappy-player.coffee'
ia = require './libs/zappy-ia.coffee'

console.log player

player.client = client
player.initMap 10, 10

client.connect(config).then ->
    console.log "Connected to ", config.host, ":", config.port
    client.send config.team
.then (message) ->
    player.seatLeft = parseInt message
    client.next()
.then (message) ->
    player.initMap (parseInt message.split(" ")[0]), (parseInt message.split(" ")[1])
    ia.start player
.fail (error) ->
    console.log "Couldn't initialize player :", error
