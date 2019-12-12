import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("twitter:interface", {})


// Get access to DOM elements from their ids
let registerUser = document.getElementById("registerUser")
let name = document.getElementById("userName")
let password = document.getElementById("password")

registerUser.addEventListener('click', e => {
  channel.push('register', {
    username: name,
    //Use a hashing algorithm here (authentication method used in the class)
    password: password
  });
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket