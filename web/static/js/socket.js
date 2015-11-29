import {Socket} from "deps/phoenix/web/static/js/phoenix"

var socket = new Socket("/socket")
var channel = socket.channel("games:lobby")
socket.connect({token: window.userToken})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
//
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.


$("#join").click(function(e) {
    e.preventDefault()
    var channel = socket.channel("games:lobby", {username: $("#username").val()})
    channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })
})

$("#drop").click(function(e) {
    e.preventDefault()
    channel.leave()
        .receive("ok", resp => { console.log("Dropped successfully", resp) })
        .receive("error", resp => { console.log("Can't leave", resp) })
})


export default socket
