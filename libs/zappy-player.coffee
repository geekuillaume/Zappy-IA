Q = require 'q'
Map = require './zappy-map.coffee'

class Player
    constructor: ->
        @map = null
        @seatLeft = -1
        @x = 0
        @y = 0
        @level = 1
        @direction = {x: 0, y: 1}

    initMap: (width, height) ->
        @map = new Map(width, height)

    go: ->
        @client.send("avance").then (message) ->
            if (message == ok)
                @x += @direction.x
                @y += @direction.y

    see: ->
        @client.send("voir").then (message) ->
            data = message[1..-2]
            increment = {x: 0, y: 0, level: 1}
            for content, i in data.split(",")
                if (i == increment.level)
                    increment.level += 2
                    if @direction.x
                        increment.x += 1
                        increment.y = @y + @direction.y * (increment.level / 2)
                    if @direction.y
                        increment.x = @x + @direction.x * (increment.level / 2)
                        increment.y += 1
                @map.set @x + increment.x, @y + increment.y, content.split(" ")

module.exports = new Player()
