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
        this.game = null;

        this.player = player // should be "player_one" or "player_two"
        this.opponent = (this.player == "player_one" ? "player_two" : "player_one")

        $('.move').on('click', function(e) {
            e.preventDefault();
            $(".move").removeClass("btn-primary");
            $(e.target).addClass("btn-primary");
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
            .receive("ok", (game => this.update(game)))

        this.channel.onError(e => console.log("CHANNEL connection error", e))
        this.channel.onClose(e => console.log("CHANNEL closed", e))

        this.channel.on("update", game => this.update(game))
    },

    update: function(info) {
        this.game = info
        console.log("UPDATE", this.game)

        if($.trim(this.game.player_one_name).length) {
            $("#player_one_name_here").html("<h1>" + this.game.player_one_name + "</h1>");
        }
        if($.trim(this.game.player_two_name).length) {
            this.player_two_joined = true;
            $("#player_two_name_here").html("<h1>" + this.game.player_two_name + "</h1>");
        }

        if (this.game.started) {
            $('#vs').fadeIn();
            $("#join_panel").fadeOut();
        }

        if (this.game.started && !this.game.outcome) {
            let $button = $("#rematch");
            $button.attr('value', "Rematch?");
            $button.attr('disabled', false)
            $("#rematch_banner").html("")

            $("#outcome").fadeOut();
            $(".player_move").fadeOut();
            $('#' + this.player + ' .moves').fadeIn();
            $("#rematch_panel").fadeOut();
        }

        if (this.game.outcome) {
            $('#player_one_move_here').html("<h2>" + this.game.player_one_move + "</h2>");
            $('#player_two_move_here').html("<h2>" + this.game.player_two_move + "</h2>");

            if(this.game.outcome == 'draw') {
                $("#outcome").html("It's a draw!");
            } else if(this.game.outcome == 'player_one') {
                $("#outcome").html(this.game.player_one_name + " wins!");
            } else if(this.game.outcome == 'player_two') {
                $("#outcome").html(this.game.player_two_name + " wins!");
            }

            $("#outcome").fadeIn();
            $('.moves').fadeOut();
            $(".move").removeClass("btn-primary");

            if(this.game.rematch == this.opponent) {
                $("#rematch").attr("value",
                                   this.game.player_two_name + " wants to go again! Accept rematch?")
            }
            $('#rematch_panel').fadeIn();
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
    },

    opponent_name: function() {
        if(this.player == "player_one") {
            this.game.player_one_name;
        } else {
            this.game.player_two_name;
        }
    }
}
