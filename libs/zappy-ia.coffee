class IA
    constructor: ->
        @player = null

    start: (player) ->
        @player = player
        promise = player.see()
        for i in [0..5]
            promise.then(player.go()).then(player.see())


module.exports = new IA()
