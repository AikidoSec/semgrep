(* Yoann Padioleau
 *
 * Copyright (C) 2021 r2c
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file LICENSE.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * LICENSE for more details.
 *)

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)
(* Small wrapper to the actual regexp engine(s).
 *
 * Regexps are used in many places in Semgrep:
 *  - in Generic_vs_generic to support the "=~/.../",
 *  - in Semgrep.ml for the metavariable-regexp and pattern-regexp
 *  - in Optimizing/ for skipping rules or target files
 *    (See Analyze_pattern.ml for more information).
 *  - TODO for include/exclude globbing
 *
 * notes: I tried to use the ocaml-re (Re) regexp libray instead of Str
 * because I thought it would be faster, and because it offers regexp
 * combinators (alt, rep, etc.) which might be useful at some point to
 * handle patterns containing explicit DisjExpr or for Analyze_rule.ml.
 * However when running on Zulip codebase with zulip semgrep rules,
 * Str is actually faster than Re.
 *
 * alternatives:
 *  - Str: simple, builtin
 *  - Re: provides alt() to build complex regexp, and also pure OCaml
 *    implem which is great in a JSOO context, but it seems slower.
 *    Can also support globbing with the Re.Glob module!
 *  - PCRE: powerful, but C dependency
 *
 * TODO:
 *  - move the regexp-related code in Generic_vs_generic here!
 *  - use Re.Glob just for globbing?
 *
 *)

(*****************************************************************************)
(* Helpers  *)
(*****************************************************************************)

(* keep the string around for show *)
type t = Pcre_.t

let pcre_pattern (x : t) = x.pattern
let pcre_regexp (x : t) = x.regexp
let show (x : t) = x.pattern
let pp fmt (x : t) = Format.fprintf fmt "\"%s\"" x.pattern
let equal (x1 : t) (x2 : t) = x1.pattern = x2.pattern
let matching_exact_string s : t = Pcre_.regexp (Pcre.quote s)

let matching_exact_word s =
  let pattern = "\b" ^ Pcre.quote s ^ "\b" in
  Pcre_.regexp pattern

let pcre_compile_with_flags ~flags pat = Pcre_.regexp ~flags pat [@@profiling]

(*
   MULTILINE = ^ and $ match at the beginning and end of lines rather than
               just at the beginning and end of input.
*)
let pcre_compile pat = Pcre_.regexp ~flags:[ `MULTILINE ] pat [@@profiling]

let anchored_match ?on_error =
  (* ~iflags are precompiled flags for better performance compared to ~flags *)
  let iflags = Pcre.rflags [ `ANCHORED ] in
  fun rex str -> Pcre_.pmatch_noerr ?on_error ~iflags ~rex str

let unanchored_match ?on_error rex str = Pcre_.pmatch_noerr ?on_error ~rex str

let may_contain_end_of_string_assertions =
  (* The absence of the following guarantees (to the best of our knowledge)
     that a regexp does not try to match the beginning or the end of
     the string:
       ^
       $
       \A
       \Z
       \z
       (?<!   negative lookbehind assertion, which could be a DIY \A
       (?!    negative lookahead assertion, which could be a DIY \z
  *)
  let rex = Pcre_.regexp {|[$^]|\\[AZz]|\(\?<!|\(\?!|} in
  fun s -> Pcre_.pmatch_noerr ~rex s

(* Any string that may still contain a end-of-string assertions must go
   through this. *)
let finish src =
  if may_contain_end_of_string_assertions src then None else Some src

(*
   Remove beginning-of-string and end-of-string constraints.
   Fail if some of them may remain e.g. if we find '^' in the middle of
   the pattern.
*)
let remove_end_of_string_assertions_from_string src : string option =
  (*
     a0 and a1 are the first two characters.
     z0 and z1 are the last two characters.
  *)
  let len = String.length src in
  if len = 0 then (* "" *)
    Some src
  else
    (* "X" *)
    let a0 = src.[0] in
    if len = 1 then
      Some
        (match a0 with
        | '^' -> ""
        | '$' -> ""
        | _ -> src)
    else
      (* "XX" *)
      let a1 = src.[1] in
      if len = 2 then
        match (a0, a1) with
        | '^', '$' -> Some ""
        | '^', c -> String.make 1 c |> finish
        | '\\', ('A' | 'Z' | 'z') -> Some ""
        | '\\', _ -> Some src
        | c, '$' -> String.make 1 c |> finish
        | _, _ -> src |> finish
      else
        (* "XXX" or longer *)
        let src =
          match (a0, a1) with
          | '^', _ -> String.sub src 1 (len - 1)
          | '\\', 'A' -> String.sub src 2 (len - 2)
          | _ -> src
        in
        (* remaining string: "X" or longer *)
        let len = String.length src in
        let z1 = src.[len - 1] in
        if len = 1 then
          match z1 with
          | '$' -> Some ""
          | _ -> src |> finish
        else
          (* remaining string: "XX" or longer *)
          let z0 = src.[len - 2] in
          match (z0, z1) with
          | '\\', ('Z' | 'z') -> Some (Str.first_chars src (len - 2))
          | '\\', _ -> Some src
          | _, '$' -> Str.first_chars src (len - 1) |> finish
          | _ -> src |> finish

let remove_end_of_string_assertions (rex : t) =
  match remove_end_of_string_assertions_from_string rex.pattern with
  | None -> None
  | Some pat -> Some (pcre_compile pat)
