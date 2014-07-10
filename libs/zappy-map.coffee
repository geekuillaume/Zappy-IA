normalize = (value, max, min = 0) ->
    while value < min
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

    set: (x, y, content) =>
        x = normalize x, @width
        y = normalize y, @height
        @_content[x][y] = content

    get: (x, y) =>
        x = normalize x, @width
        y = normalize y, @height
        return @_content[x][y]

module.exports = Map
