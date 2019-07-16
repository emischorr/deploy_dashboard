// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import {LiveSocket, debug} from "phoenix_live_view"

let logger =  function(kind, msg, data) {
  // console.log(`${kind}: ${msg}`, data)
}

let liveSocket = new LiveSocket("/live", {logger: logger})
liveSocket.connect()
window.liveSocket = liveSocket

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
