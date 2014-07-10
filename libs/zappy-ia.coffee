class IA
    constructor: ->
        @player = null

    start: (player) =>
        @player = player
        promise = @player.see()

        for i in [0..700]
            promise = promise.then @player.go
            promise = promise.then @player.see
            if (i % 7 == 0)
                promise = promise.then => @player.turn("droite")
        promise.done()


module.exports = new IA()
