module Gluten_lwt_unix = Dream_gluten_lwt_unix.Gluten_lwt_unix
module Websocketaf_lwt = Dream_websocketaf_lwt.Websocketaf_lwt

module Server = Websocketaf_lwt.Server (Gluten_lwt_unix.Server)

module Client = Websocketaf_lwt.Client (Gluten_lwt_unix.Client)
