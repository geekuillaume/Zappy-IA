normalize = (value, max, min) ->
    while value < (min || 0)
        value += max
    while value > max
        value -= max
    return value

class Map
    constructor: (width, height) ->
        @width = width
        @height = height
        @_content = new Array(width)
        for i in [0..@width]
            @_content[i] = new Array(height)
            for j in [0..@height]
                @_content[i][j] = []

    set: (x, y, content) ->
        x = normalize x
        y = normalize y
        @_content[x][y] = types
        console.log "Setting case %dx%d to %d", x, y, content

    get: (x, y) ->
        x = normalize x
        y = normalize y
        return @_content[x][y]

module.exports = Map
