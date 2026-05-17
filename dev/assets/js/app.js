import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/alexandria_dev"

import UIkit from "../../deps/elixir_uikit/priv/vendor/uikit/js/uikit.min.js"
import Icons from "../../deps/elixir_uikit/priv/vendor/uikit/js/uikit-icons.min.js"
UIkit.use(Icons)
window.UIkit = UIkit

import UikitHooks, { onBeforeElUpdated } from "../../deps/elixir_uikit/priv/static/js/elixir_uikit.js"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {...UikitHooks, ...colocatedHooks},
  dom: { onBeforeElUpdated }
})
liveSocket.connect()
window.liveSocket = liveSocket
