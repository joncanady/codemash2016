import {Socket} from "deps/phoenix/web/static/js/phoenix"

export var Game = {
    player_one_joined: false,
    player_two_joined: false,

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
            .receive("ok", (info => this.update(info)))

        this.channel.onError(e => console.log("CHANNEL connection error", e))
        this.channel.onClose(e => console.log("CHANNEL closed", e))

        this.channel.on("join", info => this.update(info))
    },

    update: function(info) {
        console.log("UPDATE", info)
        if($.trim(info.player_one_name).length && !this.player_one_joined) {
            this.player_one_joined = true;
            $("#player_one").append("<h1>" + info.player_one_name + "</h1>");
        }

        if($.trim(info.player_two_name).length && !this.player_two_joined) {
            this.player_two_joined = true;
            $("#player_two").append("<h1>" + info.player_two_name + "</h1>");
        }

        if (info.started) {
            $("#join_panel").fadeOut();
        }
    },

    join: function(player, name) {
        this.channel.push("join:" + player, {name: name})
    }
}
