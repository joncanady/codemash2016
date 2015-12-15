import {Socket} from "deps/phoenix/web/static/js/phoenix"

export var Game = {
    connect: function(game_code) {
        this.socket       = new Socket("/socket")
        this.game_code    = game_code
        this.game_channel = "games:" + game_code
        console.log("Initialized for " + game_code)
        this.socket.connect()

        this.socket.onOpen( ev => console.log("OPEN", ev) )
        this.socket.onError( ev => console.log("ERROR", ev) )
        this.socket.onClose( ev => console.log("CLOSE", ev) )

        this.channel = this.socket.channel(this.game_channel, {player_one: {name: "Player One"}})
        this.channel.join().receive("ignore", () => console.log("auth error"))
            .receive("ok", () => console.log("CHANNEL join"))
            .after(10000, () => console.log("CHANNEL connection interrupt"))

        this.channel.onError(e => console.log("CHANNEL connection error", e))
        this.channel.onClose(e => console.log("CHANNEL closed", e))

        this.channel.on("join", msg => { console.log("INCOMING", msg) })
    }
}
