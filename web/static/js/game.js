import {Socket} from "deps/phoenix/web/static/js/phoenix"

export var Game = {
    player_one_joined: false,
    player_two_joined: false,

    init: function(game_code, player) {
        this.socket       = new Socket("/socket")
        this.game_code    = game_code
        this.game_topic = "games:" + game_code
        console.log("Initialized for " + game_code)

        this.socket.onOpen( ev => console.log("OPEN", ev) )
        this.socket.onError( ev => console.log("ERROR", ev) )
        this.socket.onClose( ev => console.log("CLOSE", ev) )
        this.player = player // should be "player_one" or "player_two"
        this.opponent = (this.player == "player_one" ? "player_two" : "player_one")

        $('.move').on('click', function(e) {
            e.preventDefault();
            window.game.shoot(e.target.value);
        });

        $('#rematch').on('click', function(e){
            e.preventDefault();
            window.game.rematch($(e.target));
        });
    },

    connect: function() {
        this.socket.connect()
        this.channel = this.socket.channel(this.game_topic)
        this.channel.join()
            .receive("ok", (info => this.update(info)))

        this.channel.onError(e => console.log("CHANNEL connection error", e))
        this.channel.onClose(e => console.log("CHANNEL closed", e))

        this.channel.on("update", info => this.update(info))
    },

    update: function(info) {
        console.log("UPDATE", info)
        if($.trim(info.player_one_name).length && !this.player_one_joined) {
            this.player_one_joined = true;
            $("#player_one_name_here").html("<h1>" + info.player_one_name + "</h1>");
        }

        if($.trim(info.player_two_name).length && !this.player_two_joined) {
            this.player_two_joined = true;
            $("#player_two_name_here").html("<h1>" + info.player_two_name + "</h1>");
        }

        if (info.started) {
            $("#join_panel").fadeOut();
            $('#' + this.player + ' .moves').fadeIn();
            $('#vs').fadeIn();
        }

        if (info.outcome) {
            $('#player_one_move_here').html("<h2>" + info.player_one_move + "</h2>");
            $('#player_two_move_here').html("<h2>" + info.player_two_move + "</h2>");

            if(info.outcome == 'draw') {
                $("#outcome").html("It's a draw!");
            } else if(info.outcome == 'player_one') {
                $("#outcome").html(info.player_one_name + " wins!");
            } else if(info.outcome == 'player_two') {
                $("#outcome").html(info.player_two_name + " wins!");
            }

            $("#outcome").fadeIn();
            $('.moves').fadeOut();

            $('#rematch_panel').fadeIn();
        }

        if (info.rematch) {
            this.rematch_proposed = true;
        }
    },

    join: function(player, name) {
        this.channel.push("join:" + player, {name: name})
    },

    shoot: function(choice) {
        console.log("SHOOTING")
        choice = choice.toLowerCase();
        this.channel.push("shoot", {player: this.player, choice: choice})
    },

    rematch: function($button) {
        console.log('REMATCH!', $button);
        $button.attr('value', "Rematch requested!");
        $button.attr('disabled', true)
        this.channel.push('rematch', {player: this.player});
    }
}
