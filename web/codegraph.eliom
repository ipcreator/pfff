open Common

module H = Eliom_content.Html5.D

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(*****************************************************************************)
(* App *)
(*****************************************************************************)
module App = Eliom_registration.App (struct let application_name = "app" end)

(*****************************************************************************)
(* Shared *)
(*****************************************************************************)

{shared{
let width = 1200
let height = 680
module Model = Model_codegraph
}}

(*****************************************************************************)
(* Main entry point *)
(*****************************************************************************)
let main_service =
  App.register_service 
    ~path:["codegraph"] 
    ~get_params:(Eliom_parameter.string "path")
  (fun path () ->
    pr2 path;

    (* todo: gopti should be a param too? memoized *)
    let m = Server_codegraph.build Globals.gopti path in

    let w = { Model.
       m;
       width = width;
       height = height;
    } in

    ignore
      {unit { View_matrix_codegraph.paint %w }};
    Lwt.return
      (H.html 
          (H.head (H.title (H.pcdata "CodeGraph")) [ 
          ])
          (H.body [
            H.div 
              ~a:[H.a_id "output";] [];
            H.canvas
              ~a:[H.a_id "main_canvas"; H.a_width width; H.a_height height] [];
          ]))
  )
