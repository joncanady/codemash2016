import {Socket} from "deps/phoenix/web/static/js/phoenix"

export var Game = {
    init: function(game_code) {
        this.socket       = new Socket("/socket")
        this.game_code    = game_code
        this.game_topic = "games:" + game_code
        console.log("Initialized for " + game_code)

        this.socket.onOpen( ev => console.log("OPEN", ev) )
        this.socket.onError( ev => console.log("ERROR", ev) )
        this.socket.onClose( ev => console.log("CLOSE", ev) )
    },

    connect: function() {
        this.socket.connect()
        this.channel = this.socket.channel(this.game_topic)
        this.channel.join()
            .receive("ok", () => console.log("CHANNEL join"))

        this.channel.onError(e => console.log("CHANNEL connection error", e))
        this.channel.onClose(e => console.log("CHANNEL closed", e))

        this.channel.on("join", player_info => {
            $("#" + player_info.player).append("<h1>" + player_info.name + "</h1>");
        })
    },

    join: function(player, name) {
        this.channel.push("join:" + player, {name: name})
    }
}
