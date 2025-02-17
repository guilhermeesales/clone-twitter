import "../css/app.scss"

import "phoenix_html"

import { Socket } from "phoenix"

// Já existe a configuração do LiveSocket; vamos criar uma conexão separada para canais customizados:
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let socket = new Socket("/socket", { params: { _csrf_token: csrfToken } })

socket.connect()

// Junta-se ao canal "posts"
let postChannel = socket.channel("posts", {})
postChannel.join()
  .receive("ok", resp => { console.log("Conectado ao canal posts", resp) })
  .receive("error", resp => { console.log("Falha ao conectar ao canal posts", resp) })

// Escuta o evento "post_liked" e atualiza o número de likes na página
postChannel.on("post_liked", payload => {
  console.log("Post curtido:", payload)
  let likesElem = document.getElementById(`post-likes-${payload.post_id}`)
  if (likesElem) {
    likesElem.innerText = payload.likes
  }
})

postChannel.on("post_replied", payload => {
  console.log("Post replied:", payload)
  let repliesElem = document.getElementById(`post-replies-${payload.post_id}`)
  if (repliesElem) {
    repliesElem.innerText = payload.replies
  }
})

export default socket
