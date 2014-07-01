net = require 'net'
events = require 'events'
util = require 'util'
Q = require 'q'

class Client extends events.EventEmitter
    constructor: ->
        @buffer = ""
        @_callbackQueue = []
        events.EventEmitter.call(this);

    _dataCallback: (chunk) ->
        @buffer += chunk
        messages = @buffer.split "\n"
        for message in messages[..-2]
            @_parseMessage message
        @buffer = messages[messages.length - 1]

    _parseMessage: (message) ->
        @emit "message", message
        if @_callbackQueue.length
            @_callbackQueue.shift()(message)

    send: (message) ->
        deferred = Q.defer()
        @_callbackQueue.push (data) ->
            deferred.resolve data
        @_connection.write message + "\n"
        return deferred.promise

    next: () ->
        deferred = Q.defer()
        @_callbackQueue.push (data) ->
            deferred.resolve data
        return deferred.promise

    connect: (config) ->
        deferred = Q.defer()
        @_connection = net.connect {port: config.port, host: config.host}, =>
            @_connection.removeListener "error", errorCallback
        @_connection.setEncoding 'utf8'
        errorCallback = (error) ->
            deferred.reject error
        @_connection.once "error", errorCallback
        @_connection.on "data", @_dataCallback.bind(this)
        @next().then (data) =>
            deferred.resolve()
        return deferred.promise

module.exports = new Client()
