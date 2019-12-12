import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("twitter:interface", {})


// Get access to DOM elements from their ids
let registerUser = document.getElementById("registerUser")
let loginUser = document.getElementById("loginUser")
let name = document.getElementById("userName")
let password = document.getElementById("password")

channel.on('register', (payload) => {
  console.log(payload)
})

registerUser.addEventListener('click', e => {
  channel.push('register', {
    username: name.value,
    //Use a hashing algorithm here (authentication method used in the class)
    password: password.value
  });
  name.value = ""
  password.value = ""
});

channel.on('login', (payload) => {
  console.log(payload)
  //Here if payload.reply is equal to ok ie logged in correctly, hide the login register elements and show the user feed
});

loginUser.addEventListener('click', e => {
  channel.push('login', {
    username: name.value,
    password: password.value
  });
  // name.value = ""
  // password.value = ""
});



channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket