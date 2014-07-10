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

    initMap: (width, height) =>
        @map = new Map(width, height)

    go: =>
        deferred = Q.defer()
        @client.send("avance").then (message) =>
            if (message == "ok")
                @x += @direction.x
                @y += @direction.y
                deferred.resolve()
            else
                deferred.reject "Not ok"
        .done()
        return deferred.promise

    turn: (direction) =>
        deferred = Q.defer()
        @client.send(direction).then (message) =>
            deferred.resolve()
        return deferred.promise

    see: =>
        deferred = Q.defer()
        @client.send("voir").then (message) =>
            data = message[1..-2]
            increment = {x: 0, y: 0, level: 0}
            datas = data.split ","
            for content, i in datas
                realContent = content.split(" ").filter (obj) -> !!obj
                @map.set @x + increment.x, @y + increment.y, realContent
                if (i == increment.level)
                    increment.level += 3
                    if @direction.x
                        increment.y += 1
                        increment.x = -1 * @direction.x * Math.floor(increment.level / 2)
                    if @direction.y
                        increment.y = -1 * (@direction.y * Math.floor(increment.level / 2))
                        increment.x += 1
                else
                    increment.x += @direction.x
                    increment.y += @direction.y
            deferred.resolve()
        return deferred.promise

module.exports = new Player()
