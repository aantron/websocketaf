(*----------------------------------------------------------------------------
    Copyright (c) 2018 Inhabited Type LLC.
    Copyright (c) 2019 António Nuno Monteiro

    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    3. Neither the name of the author nor the names of his contributors
       may be used to endorse or promote products derived from this software
       without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTORS ``AS IS'' AND ANY EXPRESS
    OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
    STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
  ----------------------------------------------------------------------------*)

module Server (Flow : Mirage_flow.S) = struct
  type socket = Flow.flow

  module Server_runtime = Websocketaf_lwt.Server (Dream_gluten_mirage.Server (Flow))

  let create_connection_handler ?config ~websocket_handler ~error_handler =
    fun flow ->
      let websocket_handler = fun () -> websocket_handler in
      let error_handler = fun () -> error_handler in
      Server_runtime.create_connection_handler
       ?config
       ~websocket_handler
       ~error_handler
       ()
       flow
end

(* Almost like the `Websocketaf_lwt.Server` module type but we don't need the
 * client address argument in Mirage. It's somewhere else. *)
module type Server = sig
  open Websocketaf
  type socket

  val create_connection_handler
    :  ?config : Dream_httpaf.Config.t
    -> websocket_handler : (Wsd.t -> Server_connection.input_handlers)
    -> error_handler : Server_connection.error_handler
    -> socket
    -> unit Lwt.t
end

module type Client = Websocketaf_lwt.Client

module Client (Flow : Mirage_flow.S) =
  Websocketaf_lwt.Client (Dream_gluten_mirage.Client (Flow))
