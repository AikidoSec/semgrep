(* Yoann Padioleau
 *
 * Copyright (C) 2019, 2020 r2c
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
open OCaml
open AST_generic
module G = AST_generic
module H = AST_generic_helpers
module PI = Parse_info

(* Disable warnings against unused variables *)
[@@@warning "-26"]

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(* hooks *)
type visitor_in = {
  (* those are the one used by semgrep *)
  kexpr : (expr -> unit) * visitor_out -> expr -> unit;
  kstmt : (stmt -> unit) * visitor_out -> stmt -> unit;
  kstmts : (stmt list -> unit) * visitor_out -> stmt list -> unit;
  ktype_ : (type_ -> unit) * visitor_out -> type_ -> unit;
  kpattern : (pattern -> unit) * visitor_out -> pattern -> unit;
  kfield : (field -> unit) * visitor_out -> field -> unit;
  kfields : (field list -> unit) * visitor_out -> field list -> unit;
  kattr : (attribute -> unit) * visitor_out -> attribute -> unit;
  kpartial : (partial -> unit) * visitor_out -> partial -> unit;
  kdef : (definition -> unit) * visitor_out -> definition -> unit;
  kdir : (directive -> unit) * visitor_out -> directive -> unit;
  kparam : (parameter -> unit) * visitor_out -> parameter -> unit;
  ktparam : (type_parameter -> unit) * visitor_out -> type_parameter -> unit;
  kcatch : (catch -> unit) * visitor_out -> catch -> unit;
  kident : (ident -> unit) * visitor_out -> ident -> unit;
  kname : (name -> unit) * visitor_out -> name -> unit;
  kentity : (entity -> unit) * visitor_out -> entity -> unit;
  kfunction_definition :
    (function_definition -> unit) * visitor_out -> function_definition -> unit;
  kclass_definition :
    (class_definition -> unit) * visitor_out -> class_definition -> unit;
  kinfo : (tok -> unit) * visitor_out -> tok -> unit;
  kid_info : (id_info -> unit) * visitor_out -> id_info -> unit;
  ksvalue : (svalue -> unit) * visitor_out -> svalue -> unit;
  kargument : (argument -> unit) * visitor_out -> argument -> unit;
  klit : (literal -> unit) * visitor_out -> literal -> unit;
  ktodo : (todo_kind -> unit) * visitor_out -> todo_kind -> unit;
  kraw : (raw_tree -> unit) * visitor_out -> raw_tree -> unit;
}

and visitor_out = any -> unit

let default_visitor =
  {
    kexpr = (fun (k, _) x -> k x);
    kstmt = (fun (k, _) x -> k x);
    ktype_ = (fun (k, _) x -> k x);
    kpattern = (fun (k, _) x -> k x);
    kfield = (fun (k, _) x -> k x);
    kfields = (fun (k, _) x -> k x);
    kpartial = (fun (k, _) x -> k x);
    kdef = (fun (k, _) x -> k x);
    kdir = (fun (k, _) x -> k x);
    kattr = (fun (k, _) x -> k x);
    kparam = (fun (k, _) x -> k x);
    ktparam = (fun (k, _) x -> k x);
    kcatch = (fun (k, _) x -> k x);
    kident = (fun (k, _) x -> k x);
    kname = (fun (k, _) x -> k x);
    kentity = (fun (k, _) x -> k x);
    kstmts = (fun (k, _) x -> k x);
    kfunction_definition = (fun (k, _) x -> k x);
    kclass_definition = (fun (k, _) x -> k x);
    kinfo = (fun (k, _) x -> k x);
    (* By default, do not visit the refs in id_info *)
    kid_info =
      (fun (_k, _) x ->
        let {
          id_resolved = v_id_resolved;
          id_type = v_id_type;
          id_svalue = _IGNORED;
          id_hidden = _IGNORED2;
          id_info_id = _IGNORED3;
        } =
          x
        in
        let arg = v_ref_do_not_visit (v_option (fun _ -> ())) v_id_resolved in
        let arg = v_ref_do_not_visit (v_option (fun _ -> ())) v_id_type in
        ());
    ksvalue = (fun (k, _) x -> k x);
    kargument = (fun (k, _) x -> k x);
    klit = (fun (k, _) x -> k x);
    ktodo = (fun (k, _) x -> k x);
    kraw = (fun (k, _) x -> k x);
  }

let v_id _ = ()
let v_sid _ = ()

let (mk_visitor :
      ?vardef_assign:bool ->
      ?flddef_assign:bool ->
      ?attr_expr:bool ->
      visitor_in ->
      visitor_out) =
 fun ?(vardef_assign = false) ?(flddef_assign = false) ?(attr_expr = false) vin ->
  (* start of auto generation *)
  (* NOTE: we do a few subtle things at a few places now for semgrep
   * to trigger a few more artificial visits:
   *  - we call vardef_to_assign (if `vardef_assign` is `true`)
   *  - we generate partial defs on the fly and call kpartial
   *  - we call v_expr on nested XmlXml to give the chance for an
   *    Xml pattern to also be matched against nested Xml elements
   *
   * old: We used to apply the VarDef-Assign equivalence by default, but
   * this was error prone because visitors typically do side-effectful
   * things and VarDefs were visited twice (as a VarDef and as an Assign),
   * thus repeating side-effects, leading to surprises.
   *)

  (* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_visitor.cmo  pr_o.cmo /tmp/xxx.ml  *)
  let rec v_info x =
    let k x =
      match x with
      | { PI.token = _v_pinfox; transfo = _v_transfo } ->
          (*
    let arg = PI.v_pinfo v_pinfox in
    let arg = v_unit v_comments in
    let arg = PI.v_transformation v_transfo in
*)
          ()
    in
    vin.kinfo (k, all_functions) x
  and v_tok v = v_info v
  and v_wrap : 'a. ('a -> unit) -> 'a wrap -> unit =
   fun _of_a (v1, v2) ->
    let v1 = _of_a v1 and v2 = v_info v2 in
    ()
  and v_bracket : 'a. ('a -> unit) -> 'a bracket -> unit =
   fun of_a (v1, v2, v3) ->
    let v1 = v_info v1 and v2 = of_a v2 and v3 = v_info v3 in
    ()
  and v_ident v =
    let k x = v_wrap v_string x in
    vin.kident (k, all_functions) v
  and v_dotted_ident v = v_list v_ident v
  and v_ident_and_targs (v1, v2) =
    v_ident v1;
    v_option v_type_arguments v2
  and v_qualifier = function
    | QDots v -> v_list v_ident_and_targs v
    | QExpr (e, t) ->
        v_expr e;
        v_tok t
  and v_unique_name { dotted = v1; tok = _IGNORED } =
    let v1 = v_dotted_ident v1 in
    ()
  and v_module_name = function
    | FileName v1 ->
        let v1 = v_wrap v_string v1 in
        ()
    | DottedName v1 ->
        let v1 = v_dotted_ident v1 in
        ()
  and v_resolved_name (v1, v2) =
    v_resolved_name_kind v1;
    v_sid v2
  and v_resolved_name_kind = function
    | LocalVar -> ()
    | Parameter -> ()
    | EnclosedVar -> ()
    | Global -> ()
    | ImportedEntity v1 ->
        let v1 = v_dotted_ident v1 in
        ()
    | ImportedModule v1 ->
        let v1 = v_module_name v1 in
        ()
    | Macro -> ()
    | EnumConstant -> ()
    | TypeName -> ()
    | ResolvedName (v1, v2) ->
        let v1 = v_unique_name v1 in
        let v2 = v_list v_unique_name v2 in
        ()
  and v_name_info
      { name_middle = v4; name_top = v3; name_last = v1; name_info = v2 } =
    let v1 = v_ident_and_targs v1 in
    let v2 = v_id_info v2 in
    let arg = v_option v_qualifier v4 in
    let arg = v_option v_tok v3 in
    ()
  and v_id_info x =
    let k x =
      let {
        id_resolved = v_id_resolved;
        id_type = v_id_type;
        id_svalue = v_id_svalue;
        id_hidden = v_id_hidden;
        id_info_id = _IGNORED;
      } =
        x
      in
      let arg = v_ref_do_visit (v_option v_resolved_name) v_id_resolved in
      let arg = v_ref_do_visit (v_option v_type_) v_id_type in
      let arg = v_ref_do_visit (v_option v_svalue) v_id_svalue in
      let arg = v_hidden v_id_hidden in
      ()
    in
    vin.kid_info (k, all_functions) x
  and v_xml_attribute v =
    match v with
    | XmlAttr (v1, t, v2) ->
        v_ident v1;
        v_tok t;
        v_xml_attr v2
    | XmlAttrExpr v -> v_bracket v_expr v
    | XmlEllipsis v -> v_tok v
  and v_xml
      { xml_kind = v_xml_tag; xml_attrs = v_xml_attrs; xml_body = vv_xml_body }
      =
    let v_xml_tag = v_xml_kind v_xml_tag in
    let v_xml_attrs = v_list v_xml_attribute v_xml_attrs in
    let vv_xml_body = v_list v_xml_body vv_xml_body in
    ()
  and v_xml_attr v = v_expr v
  and v_xml_kind = function
    | XmlClassic (v0, v1, v2, v3) ->
        v_tok v0;
        v_ident v1;
        v_tok v2;
        v_tok v3
    | XmlSingleton (v0, v1, v2) ->
        v_tok v0;
        v_ident v1;
        v_tok v2
    | XmlFragment (v1, v2) ->
        v_tok v1;
        v_tok v2
  and v_xml_body = function
    | XmlText v1 ->
        let v1 = v_wrap v_string v1 in
        ()
    | XmlExpr v1 ->
        let v1 = v_bracket (v_option v_expr) v1 in
        ()
    | XmlXml v1 ->
        (* subtle: old: let v1 = v_xml v1 in ()
         * We want a simple Expr (Xml ...) pattern to also be matched
         * against nested XmlXml elements *)
        v_expr (Xml v1 |> G.e)
  and v_name x =
    let k x =
      match x with
      | Id (v1, v2) ->
          let v1 = v_ident v1 and v2 = v_id_info v2 in
          ()
      | IdQualified v1 ->
          let v1 = v_name_info v1 in
          ()
    in
    vin.kname (k, all_functions) x
  and v_expr x =
    let k x =
      match x.e with
      | ParenExpr v1 -> v_bracket v_expr v1
      | DotAccessEllipsis (v1, v2) ->
          v_expr v1;
          v_tok v2
      | DisjExpr (v1, v2) ->
          let v1 = v_expr v1 in
          let v2 = v_expr v2 in
          ()
      | L v1 ->
          let v1 = v_literal v1 in
          ()
      | Ellipsis v1 ->
          let v1 = v_tok v1 in
          ()
      | DeepEllipsis v1 ->
          let v1 = v_bracket v_expr v1 in
          ()
      | Container (v1, v2) ->
          (match v1 with
          (* less: could factorize with case below by doing List|Dict here and
           * below in Tuple a String|Id
           *)
          | Dict ->
              v2 |> unbracket
              |> List.iter (fun e ->
                     match e.e with
                     | Container
                         (Tuple, (tok, [ { e = L (String id); _ }; e ], _)) ->
                         let t = PI.fake_info tok ":" in
                         v_partial ~recurse:false
                           (PartialSingleField (id, t, e))
                     | _ -> ())
          (* for Go where we use List for composite literals.
           * TODO? generate Dict in go_to_generic.ml instead directly?
           *)
          | List ->
              v2 |> unbracket
              |> List.iter (fun e ->
                     match e.e with
                     | Container
                         (Tuple, (tok, [ { e = N (Id (id, _)); _ }; e ], _)) ->
                         let t = PI.fake_info tok ":" in
                         v_partial ~recurse:false
                           (PartialSingleField (id, t, e))
                     | _ -> ())
          | _ -> ());
          let v1 = v_container_operator v1
          and v2 = v_bracket (v_list v_expr) v2 in
          ()
      | Comprehension (v1, v2) ->
          let v1 = v_container_operator v1
          and v2 = v_bracket v_comprehension v2 in
          ()
      | Record v1 ->
          let v1 = v_bracket v_fields v1 in
          ()
      | Constructor (v1, v2) ->
          let v1 = v_name v1 and v2 = v_bracket (v_list v_expr) v2 in
          ()
      | RegexpTemplate (v1, v2) ->
          let v1 = v_bracket v_expr v1 in
          let v2 = v_option (v_wrap v_string) v2 in
          ()
      | Lambda v1 ->
          let v1 = v_function_definition v1 in
          ()
      | AnonClass v1 ->
          let v1 = v_class_definition v1 in
          ()
      | Xml v1 ->
          let v1 = v_xml v1 in
          ()
      | N v1 -> v_name v1
      | IdSpecial v1 ->
          let v1 = v_wrap v_special v1 in
          ()
      | Call (v1, v2) ->
          let v1 = v_expr v1 and v2 = v_arguments v2 in
          ()
      | New (v0, v1, v2) ->
          v_tok v0;
          let v1 = v_type_ v1 and v2 = v_arguments v2 in
          ()
      | Assign (v1, v2, v3) ->
          let v1 = v_expr v1 and v2 = v_tok v2 and v3 = v_expr v3 in
          ()
      | AssignOp (v1, v2, v3) ->
          let v1 = v_expr v1
          and v2 = v_wrap v_arithmetic_operator v2
          and v3 = v_expr v3 in
          ()
      | LetPattern (v1, v2) ->
          let v1 = v_pattern v1 and v2 = v_expr v2 in
          ()
      | DotAccess (v1, t, v2) ->
          let v1 = v_expr v1 and t = v_tok t and v2 = v_field_name v2 in
          ()
      | ArrayAccess (v1, v2) ->
          let v1 = v_expr v1 and v2 = v_bracket v_expr v2 in
          ()
      | SliceAccess (v1, v2) ->
          let v1 = v_expr v1
          and v2 =
            v_bracket
              (fun (v1, v2, v3) ->
                v_option v_expr v1;
                v_option v_expr v2;
                v_option v_expr v3)
              v2
          in
          ()
      | Conditional (v1, v2, v3) ->
          let v1 = v_expr v1 and v2 = v_expr v2 and v3 = v_expr v3 in
          ()
      | TypedMetavar (v1, v2, v3) ->
          let v1 = v_ident v1 and v2 = v_tok v2 and v3 = v_type_ v3 in
          ()
      | Yield (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_option v_expr v1 and v2 = v_bool v2 in
          ()
      | Await (t, v1) ->
          let t = v_tok t in
          let v1 = v_expr v1 in
          ()
      | Cast (v1, t, v2) ->
          let v1 = v_type_ v1 and t = v_tok t and v2 = v_expr v2 in
          ()
      | Seq v1 ->
          let v1 = v_list v_expr v1 in
          ()
      | Ref (t, v1) ->
          let t = v_tok t in
          let v1 = v_expr v1 in
          ()
      | DeRef (t, v1) ->
          let t = v_tok t in
          let v1 = v_expr v1 in
          ()
      | Alias (alias, v1) ->
          let alias = v_wrap v_string alias in
          let v1 = v_expr v1 in
          ()
      | StmtExpr v1 ->
          let v1 = v_stmt v1 in
          ()
      | OtherExpr (v1, v2) ->
          let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
          ()
      | RawExpr v -> v_raw_tree v
    in
    vin.kexpr (k, all_functions) x
  and v_field_name = function
    | FN v1 -> v_name v1
    | FDynamic e -> v_expr e
  and v_entity_name = function
    | EN v1 -> v_name v1
    | EDynamic e -> v_expr e
    | EPattern x -> v_pattern x
    | OtherEntity (v1, v2) ->
        let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
        ()
  and v_literal x =
    let k = function
      | Unit v1 ->
          let v1 = v_tok v1 in
          ()
      | Bool v1 ->
          let v1 = v_wrap v_bool v1 in
          ()
      | Int v1 ->
          let v1 = v_wrap v_id v1 in
          ()
      | Float v1 ->
          let v1 = v_wrap v_id v1 in
          ()
      | Imag v1 ->
          let v1 = v_wrap v_string v1 in
          ()
      | Ratio v1 ->
          let v1 = v_wrap v_string v1 in
          ()
      | Atom (v0, v1) ->
          let v0 = v_tok v0 in
          let v1 = v_wrap v_string v1 in
          ()
      | Char v1 ->
          let v1 = v_wrap v_string v1 in
          ()
      | String v1 ->
          let v1 = v_wrap v_string v1 in
          ()
      | Regexp (v1, v2) ->
          let v1 = v_bracket (v_wrap v_string) v1 in
          let v2 = v_option (v_wrap v_string) v2 in
          ()
      | Null v1 ->
          let v1 = v_tok v1 in
          ()
      | Undefined v1 ->
          let v1 = v_tok v1 in
          ()
    in
    vin.klit (k, all_functions) x
  and v_const_type = function
    | Cbool -> ()
    | Cint -> ()
    | Cstr -> ()
    | Cany -> ()
  and v_svalue x =
    let k = function
      | Lit v1 ->
          let v1 = v_literal v1 in
          ()
      | Cst v1 ->
          let v1 = v_const_type v1 in
          ()
      | Sym v1 ->
          let v1 = v_expr v1 in
          ()
      | NotCst -> ()
    in
    vin.ksvalue (k, all_functions) x
  and v_hidden _is_hidden = ()
  and v_container_operator _x = ()
  and v_comprehension (v1, v2) =
    let v1 = v_expr v1 in
    let v2 = v_list v_for_or_if_comp v2 in
    ()
  and v_for_or_if_comp = function
    | CompFor (v1, v2, v3, v4) ->
        let v1 = v_tok v1 in
        let v2 = v_pattern v2 in
        let v3 = v_tok v3 in
        let v4 = v_expr v4 in
        ()
    | CompIf (v1, v2) ->
        let v1 = v_tok v1 in
        let v2 = v_expr v2 in
        ()
  and v_special = function
    | ForOf -> ()
    | Defined -> ()
    | This -> ()
    | Super -> ()
    | Self -> ()
    | Parent -> ()
    | Eval -> ()
    | Typeof -> ()
    | Instanceof -> ()
    | Sizeof -> ()
    | Spread -> ()
    | HashSplat -> ()
    | NextArrayIndex -> ()
    | Require -> ()
    | EncodedString v1 ->
        let v1 = v_string v1 in
        ()
    | Op v1 ->
        let v1 = v_arithmetic_operator v1 in
        ()
    | IncrDecr (v1, v2) ->
        let v1 = v_incr_decr v1 and v2 = v_prepost v2 in
        ()
    | ConcatString v1 ->
        let v1 = v_interpolated_kind v1 in
        ()
    | InterpolatedElement -> ()
  and v_interpolated_kind _ = ()
  and v_incr_decr _ = ()
  and v_prepost _ = ()
  and v_arithmetic_operator _x = ()
  and v_arguments v = v_bracket (v_list v_argument) v
  and v_required _x = ()
  and v_argument x =
    let k = function
      | Arg v1 ->
          let v1 = v_expr v1 in
          ()
      | ArgType v1 ->
          let v1 = v_type_ v1 in
          ()
      | ArgKwd (v1, v2) ->
          let tok = snd v1 in
          let t = PI.fake_info tok ":" in
          v_partial ~recurse:false (PartialSingleField (v1, t, v2));
          let v1 = v_ident v1 and v2 = v_expr v2 in
          ()
      | ArgKwdOptional (v1, v2) ->
          let v1 = v_ident v1 and v2 = v_expr v2 in
          ()
      | OtherArg (v1, v2) ->
          let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
          ()
    in
    vin.kargument (k, all_functions) x
  and v_type_ x =
    let k { t; t_attrs } =
      v_list v_attribute t_attrs;
      match t with
      | TyEllipsis v1 -> v_tok v1
      | TyRecordAnon (v0, v1) ->
          v_class_kind v0;
          let v1 = v_bracket v_fields v1 in
          ()
      | TyOr (v1, v2, v3) ->
          v_type_ v1;
          v_tok v2;
          v_type_ v3
      | TyAnd (v1, v2, v3) ->
          v_type_ v1;
          v_tok v2;
          v_type_ v3
      | TyFun (v1, v2) ->
          let v1 = v_list v_parameter v1 and v2 = v_type_ v2 in
          ()
      | TyApply (v1, v2) ->
          let v1 = v_type_ v1 and v2 = v_type_arguments v2 in
          ()
      | TyN v1 -> v_name v1
      | TyVar v1 ->
          let v1 = v_ident v1 in
          ()
      | TyAny v1 ->
          let v1 = v_tok v1 in
          ()
      | TyArray (v1, v2) ->
          let v1 = v_bracket (v_option v_expr) v1 and v2 = v_type_ v2 in
          ()
      | TyPointer (t, v1) ->
          let t = v_tok t in
          let v1 = v_type_ v1 in
          ()
      | TyRef (t, v1) ->
          let t = v_tok t in
          let v1 = v_type_ v1 in
          ()
      | TyTuple v1 ->
          let v1 = v_bracket (v_list v_type_) v1 in
          ()
      | TyQuestion (v1, t) ->
          let t = v_tok t in
          let v1 = v_type_ v1 in
          ()
      | TyRest (t, v1) ->
          let t = v_tok t in
          let v1 = v_type_ v1 in
          ()
      | TyExpr v1 ->
          let v1 = v_expr v1 in
          ()
      | OtherType (v1, v2) ->
          let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
          ()
    in
    vin.ktype_ (k, all_functions) x
  and v_type_arguments v = v_bracket (v_list v_type_argument) v
  and v_type_argument = function
    | TA v1 ->
        let v1 = v_type_ v1 in
        ()
    | TAWildcard (v1, v2) -> (
        v_tok v1;
        match v2 with
        | None -> ()
        | Some (v1, v2) ->
            v_wrap v_bool v1;
            v_type_ v2)
    | TAExpr v1 ->
        let v1 = v_expr v1 in
        ()
    | OtherTypeArg (v1, v2) ->
        let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
        ()
  (* bugfix: do not call v_ident here, otherwise code like
   * Analyze_pattern might consider the string for -filter_irrelevant_rules
   *)
  and v_todo_kind x =
    let k x =
      let _str, tok = x in
      v_tok tok
    in
    vin.ktodo (k, all_functions) x
  and v_other_type_operator _ = ()
  and v_type_parameter x =
    let k x =
      match x with
      | TParamEllipsis v1 -> v_tok v1
      | TP v1 -> v_type_parameter_classic v1
      | OtherTypeParam (t, xs) ->
          let t = v_todo_kind t in
          let xs = v_list v_any xs in
          ()
    in
    vin.ktparam (k, all_functions) x
  and v_type_parameter_classic
      {
        tp_id = v1;
        tp_attrs = v2;
        tp_bounds = v3;
        tp_default = v4;
        tp_variance = v5;
      } =
    v_ident v1;
    v_list v_attribute v2;
    v_list v_type_ v3;
    v_option v_type_ v4;
    v_option (v_wrap v_variance) v5;
    ()
  and v_variance _ = ()
  and v_attribute x =
    let k x =
      match x with
      | KeywordAttr v1 ->
          let v1 = v_wrap v_keyword_attribute v1 in
          ()
      | NamedAttr (t, v1, v3) ->
          let _ = v_named_attr_as_expr v1 v3 in
          let t = v_tok t in
          let v1 = v_name v1 and v3 = v_bracket (v_list v_argument) v3 in
          ()
      | OtherAttribute (v1, v2) ->
          let v1 = v_other_attribute_operator v1 and v2 = v_list v_any v2 in
          ()
    in
    vin.kattr (k, all_functions) x
  and v_keyword_attribute _ = ()
  and v_named_attr_as_expr name args =
    (* A named attribute is essentially a function call, but this is not
     * explicit in Generic so we cannot match expression patterns against
     * attributes. This equivalence enables exactly that, and we can e.g.
     * match `@f(a)` with `f($X)`. *)
    if attr_expr then v_expr (e (Call (e (N name), args)))
  and v_other_attribute_operator _ = ()
  and v_stmts xs =
    let k xs =
      match xs with
      | [] -> ()
      | x :: xs ->
          v_stmt x;
          (* we will call the visitor also on subsequences. This is useful
           * for semgrep *)
          v_stmts xs
    in
    vin.kstmts (k, all_functions) xs
  and v_cases_and_body x =
    v_partial ~recurse:false (PartialSwitchCase x);
    match x with
    | CasesAndBody (v1, v2) ->
        let v1 = v_list v_case v1 and v2 = v_stmt v2 in
        ()
    | CaseEllipsis v1 -> v_tok v1
  and v_stmt x =
    let k x =
      (* todo? visit the s_id too? *)
      match x.s with
      | DisjStmt (v1, v2) ->
          let v1 = v_stmt v1 in
          let v2 = v_stmt v2 in
          ()
      | ExprStmt (v1, t) ->
          let v1 = v_expr v1 in
          let t = v_tok t in
          ()
      | DefStmt v1 ->
          let v1 = v_def v1 in
          ()
      | DirectiveStmt v1 ->
          let v1 = v_directive v1 in
          ()
      | Block v1 ->
          let v1 = v_bracket v_stmts v1 in
          ()
      | If (t, Cond v1, v2, v3) ->
          v_partial ~recurse:false (PartialIf (t, v1));
          let t = v_tok t in
          let v1 = v_expr v1 and v2 = v_stmt v2 and v3 = v_option v_stmt v3 in
          ()
      | If (t, v1, v2, v3) ->
          let t = v_tok t in
          let v1 = v_condition v1
          and v2 = v_stmt v2
          and v3 = v_option v_stmt v3 in
          ()
      | While (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_condition v1 and v2 = v_stmt v2 in
          ()
      | DoWhile (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_stmt v1 and v2 = v_expr v2 in
          ()
      | For (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_for_header v1 and v2 = v_stmt v2 in
          ()
      | Switch (v0, v1, v2) ->
          (match v1 with
          | Some (G.Cond v1) -> v_partial ~recurse:false (PartialMatch (v0, v1))
          | _ -> ());
          let v0 = v_tok v0 in
          let v1 = v_option v_condition v1
          and v2 = v_list v_cases_and_body v2 in
          ()
      | Return (t, v1, sc) ->
          let t = v_tok t in
          let v1 = v_option v_expr v1 in
          v_tok sc
      | Continue (t, v1, sc) ->
          let t = v_tok t in
          let v1 = v_label_ident v1 in
          v_tok sc
      | Break (t, v1, sc) ->
          let t = v_tok t in
          let v1 = v_label_ident v1 in
          v_tok sc
      | Label (v1, v2) ->
          let v1 = v_label v1 and v2 = v_stmt v2 in
          ()
      | Goto (t, v1, sc) ->
          let t = v_tok t in
          let v1 = v_label v1 in
          v_tok sc
      | Throw (t, v1, sc) ->
          let t = v_tok t in
          let v1 = v_expr v1 in
          v_tok sc
      | Try (t, v1, v2, v3) ->
          v_partial ~recurse:false (PartialTry (t, v1));
          let t = v_tok t in
          let v1 = v_stmt v1
          and v2 = v_list v_catch v2
          and v3 = v_option v_finally v3 in
          ()
      | WithUsingResource (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_list v_stmt v1 and v2 = v_stmt v2 in
          ()
      | Assert (t, args, sc) ->
          let t = v_tok t in
          let _ = v_arguments args in
          v_tok sc
      | OtherStmtWithStmt (v1, v2, v3) ->
          let v1 = v_other_stmt_with_stmt_operator v1
          and v2 = v_list v_any v2
          and v3 = v_stmt v3 in
          ()
      | OtherStmt (v1, v2) ->
          let v1 = v_other_stmt_operator v1 and v2 = v_list v_any v2 in
          ()
    in
    vin.kstmt (k, all_functions) x
  and v_condition = function
    | Cond e -> v_expr e
    | OtherCond (v1, v2) ->
        let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
        ()
  and v_other_stmt_with_stmt_operator _ = ()
  and v_label_ident = function
    | LNone -> ()
    | LId v1 ->
        let v1 = v_label v1 in
        ()
    | LInt v1 ->
        let v1 = v_wrap v_int v1 in
        ()
    | LDynamic v1 ->
        let v1 = v_expr v1 in
        ()
  and v_case = function
    | OtherCase (v1, v2) ->
        v_todo_kind v1;
        v_list v_any v2
    | Case (t, v1) ->
        let t = v_tok t in
        let v1 = v_pattern v1 in
        ()
    | CaseEqualExpr (t, v1) ->
        let t = v_tok t in
        let v1 = v_expr v1 in
        ()
    | Default t ->
        let t = v_tok t in
        ()
  and v_catch x =
    let k (t, v1, v2) =
      v_partial ~recurse:false (PartialCatch (t, v1, v2));
      let t = v_tok t in
      let v1 = v_catch_exn v1 and v2 = v_stmt v2 in
      ()
    in
    vin.kcatch (k, all_functions) x
  and v_catch_exn = function
    | OtherCatch (v1, v2) ->
        v_todo_kind v1;
        v_list v_any v2
    | CatchPattern p -> v_pattern p
    | CatchParam p -> v_parameter_classic p
  and v_finally (t, v) =
    v_partial ~recurse:false (PartialFinally (t, v));
    let t = v_tok t in
    v_stmt v
  and v_label v = v_ident v
  and v_for_header = function
    | ForClassic (v1, v2, v3) ->
        let v1 = v_list v_for_var_or_expr v1
        and v2 = v_option v_expr v2
        and v3 = v_option v_expr v3 in
        ()
    | ForEach v1 -> v_for_each v1
    | MultiForEach v1 -> v_list v_multi_for_each v1
    | ForEllipsis t -> v_tok t
    | ForIn (v1, v2) ->
        let v1 = v_list v_for_var_or_expr v1 and v2 = v_list v_expr v2 in
        ()
  and v_for_each (v1, t, v2) =
    let t = v_tok t in
    let v1 = v_pattern v1 and v2 = v_expr v2 in
    ()
  and v_multi_for_each = function
    | FE v1 -> v_for_each v1
    | FECond (v1, t, v2) ->
        v_for_each v1;
        v_tok t;
        v_expr v2
    | FEllipsis t -> v_tok t
  and v_for_var_or_expr = function
    | ForInitVar (v1, v2) ->
        let v1 = v_entity v1 and v2 = v_variable_definition v2 in
        ()
    | ForInitExpr v1 ->
        let v1 = v_expr v1 in
        ()
  and v_other_stmt_operator _x = ()
  and v_pattern x =
    let k x =
      match x with
      | PatEllipsis v1 -> v_tok v1
      | PatRecord v1 ->
          let v1 =
            v_bracket
              (v_list (fun (v1, v2) ->
                   let v1 = v_dotted_ident v1 and v2 = v_pattern v2 in
                   ()))
              v1
          in
          ()
      | PatId (v1, v2) ->
          let v1 = v_ident v1 and v2 = v_id_info v2 in
          ()
      | PatLiteral v1 ->
          let v1 = v_literal v1 in
          ()
      | PatType v1 ->
          let v1 = v_type_ v1 in
          ()
      | PatConstructor (v1, v2) ->
          let v1 = v_name v1 and v2 = v_list v_pattern v2 in
          ()
      | PatTuple (_, v1, _) ->
          let v1 = v_list v_pattern v1 in
          ()
      | PatList v1 ->
          let v1 = v_bracket (v_list v_pattern) v1 in
          ()
      | PatKeyVal (v1, v2) ->
          let v1 = v_pattern v1 and v2 = v_pattern v2 in
          ()
      | PatUnderscore v1 ->
          let v1 = v_tok v1 in
          ()
      | PatDisj (v1, v2) ->
          let v1 = v_pattern v1 and v2 = v_pattern v2 in
          ()
      | DisjPat (v1, v2) ->
          let v1 = v_pattern v1 and v2 = v_pattern v2 in
          ()
      | PatTyped (v1, v2) ->
          let v1 = v_pattern v1 and v2 = v_type_ v2 in
          ()
      | PatAs (v1, v2) ->
          let v1 = v_pattern v1
          and v2 =
            match v2 with
            | v1, v2 ->
                let v1 = v_ident v1 and v2 = v_id_info v2 in
                ()
          in
          ()
      | PatWhen (v1, v2) ->
          let v1 = v_pattern v1 and v2 = v_expr v2 in
          ()
      | OtherPat (v1, v2) ->
          let v1 = v_other_pattern_operator v1 and v2 = v_list v_any v2 in
          ()
    in
    vin.kpattern (k, all_functions) x
  and v_other_pattern_operator _ = ()
  and v_def x =
    let k x =
      let v1, v2 = x in
      let _ = v_vardef_as_assign_expr v1 v2 in
      let _ = v_def_as_partial v1 v2 in
      let v1 = v_entity v1 and v2 = v_def_kind v2 in
      ()
    in
    vin.kdef (k, all_functions) x
  (* WEIRD: not sure why, but using this code below instead of
   * the v_def_as_partial above cause some regressions.
   *
   *  (* calling kpartial with a modified def *)
   *  (match x with
   *  | ent, FuncDef def ->
   *     let partial_def = { def with fbody = empty_fbody } in
   *     v_partial (PartialDef (ent, FuncDef partial_def))
   *  | _ -> ()
   *  )
   *)
  and v_def_as_partial ent defkind =
    (* calling kpartial with a modified def *)
    match defkind with
    | FuncDef def ->
        let partial_def = { def with fbody = FBNothing } in
        v_partial ~recurse:false (PartialDef (ent, FuncDef partial_def))
    | ClassDef def ->
        let partial_def = { def with cbody = empty_body } in
        v_partial ~recurse:false (PartialDef (ent, ClassDef partial_def))
    | _ -> ()
  (* The recurse argument is subtle. It is needed because we
   * want different behaviors depending on the context:
   * - in some context we want to recurse, for example when
   *   we call ii_of_any (Partial ...), we want to get all the tokens in it
   * - in other context we do not want to recurse, because that would mean
   *   we would visit two times the same function (one with a body, and one
   *   without a body), which can lead some code, e.g., Naming_AST, to generate
   *   intermediate sids which in turn lead to regressions in end-2-end tests
   *   (because the value of sid differ).
   * This is why when we are called from v_any, we recurse (case 1), but
   * when we are called from a v_def, we don't.
   *)
  and v_partial ~recurse x =
    let k x =
      match x with
      | PartialDef (v1, v2) ->
          (* Do not call v_def here, otherwise you'll get infinite loop *)
          if recurse then (
            v_entity v1;
            v_def_kind v2);
          ()
      | PartialIf (v1, v2)
      | PartialMatch (v1, v2) ->
          if recurse then (
            v_tok v1;
            v_expr v2)
      | PartialTry (v1, v2) ->
          if recurse then (
            v_tok v1;
            v_stmt v2)
      | PartialCatch v1 -> if recurse then v_catch v1
      | PartialFinally (v1, v2) ->
          if recurse then (
            v_tok v1;
            v_stmt v2)
      | PartialSingleField (v1, v2, v3) ->
          if recurse then (
            v_wrap v_string v1;
            v_tok v2;
            v_expr v3)
      | PartialLambdaOrFuncDef v1 -> if recurse then v_function_definition v1
      | PartialSwitchCase v1 -> if recurse then v_cases_and_body v1
    in
    vin.kpartial (k, all_functions) x
  and v_entity x =
    let k x =
      let { name = x_name; attrs = v_attrs; tparams = v_tparams } = x in
      let arg = v_entity_name x_name in
      let arg = v_list v_attribute v_attrs in
      let arg = v_list v_type_parameter v_tparams in
      ()
    in
    vin.kentity (k, all_functions) x
  and v_enum_entry_definition { ee_args; ee_body } =
    v_option v_arguments ee_args;
    v_option (v_bracket (v_list v_field)) ee_body
  and v_def_kind = function
    | EnumEntryDef v1 ->
        let v1 = v_enum_entry_definition v1 in
        ()
    | FuncDef v1 ->
        let v1 = v_function_definition v1 in
        ()
    | VarDef v1 ->
        let v1 = v_variable_definition v1 in
        ()
    | FieldDefColon v1 ->
        let v1 = v_variable_definition v1 in
        ()
    | ClassDef v1 ->
        let v1 = v_class_definition v1 in
        ()
    | TypeDef v1 ->
        let v1 = v_type_definition v1 in
        ()
    | ModuleDef v1 ->
        let v1 = v_module_definition v1 in
        ()
    | MacroDef v1 ->
        let v1 = v_macro_definition v1 in
        ()
    | Signature v1 ->
        let v1 = v_type_ v1 in
        ()
    | UseOuterDecl v1 ->
        let v1 = v_tok v1 in
        ()
    | OtherDef (v1, v2) ->
        v_other_def_operator v1;
        v_list v_any v2
  and v_other_def_operator _ = ()
  and v_function_kind = function
    | Function
    | Method
    | Arrow
    | LambdaKind
    | BlockCases ->
        ()
  and v_function_definition x =
    let k { fkind; fparams = v_fparams; frettype = v_frettype; fbody = v_fbody }
        =
      v_partial ~recurse:false (PartialLambdaOrFuncDef x);

      v_wrap v_function_kind fkind;
      let arg = v_parameters v_fparams in
      let arg = v_option v_type_ v_frettype in
      let arg = v_function_body v_fbody in
      ()
    in
    vin.kfunction_definition (k, all_functions) x
  and v_parameters v = v_list v_parameter v
  and v_parameter x =
    let k x =
      match x with
      | Param v1 ->
          let v1 = v_parameter_classic v1 in
          ()
      | ParamRest (v1, v2)
      | ParamHashSplat (v1, v2) ->
          v_tok v1;
          v_parameter_classic v2
      | ParamPattern v1 ->
          let v1 = v_pattern v1 in
          ()
      | ParamEllipsis v1 ->
          let v1 = v_tok v1 in
          ()
      | OtherParam (v1, v2) ->
          let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
          ()
    in
    vin.kparam (k, all_functions) x
  and v_parameter_classic
      {
        pname = v_pname;
        pdefault = v_pdefault;
        ptype = v_ptype;
        pattrs = v_pattrs;
        pinfo = v_pinfo;
      } =
    let arg = v_id_info v_pinfo in
    let arg = v_option v_ident v_pname in
    let arg = v_option v_expr v_pdefault in
    let arg = v_option v_type_ v_ptype in
    let arg = v_list v_attribute v_pattrs in
    ()
  and v_other_parameter_operator _ = ()
  and v_function_body = function
    | FBStmt v1 -> v_stmt v1
    | FBExpr v1 -> v_expr v1
    | FBDecl v1 -> v_tok v1
    | FBNothing -> ()
  and v_variable_definition { vinit = v_vinit; vtype = v_vtype } =
    let v_vinit = v_option v_expr v_vinit in
    let v_vtype = v_option v_type_ v_vtype in
    ()
  and v_vardef_as_assign_expr ventity = function
    | VarDef ({ vinit = Some _; _ } as vdef) when vardef_assign ->
        (* A VarDef is implicitly a declaration followed by an assignment expression,
         * so we should visit the assignment expression as well.
         *
         * Note that we cannot treat this as a simple equivalence later, as
         * expressions are visited separately from statements.
         *
         * This feels a bit hacky here, so let's take a TODO to improve this
         *)
        v_expr (H.vardef_to_assign (ventity, vdef))
    | _ -> ()
  and v_flddef_as_assign_expr ventity = function
    (* No need to cover the VarDef({vinit = Some _; )} case here. It will
     * be covered by v_vardef_as_assign_expr at some point when v_field
     * below call v_stmt (which itself will call v_def).
     *
     * In certain languages like Javascript, some method definitions look
     * really like assignements, so we would like an expression pattern like
     * '$X = function() { ...}' to also match code like
     * 'class Foo { x = function() { return; } }'.
     *)
    | FuncDef fdef when flddef_assign ->
        let resolved = Some (LocalVar, G.SId.unsafe_default) in
        v_expr (H.funcdef_to_lambda (ventity, fdef) resolved)
    | _ -> ()
  and v_field x =
    let k x =
      match x with
      | F v1 ->
          (match v1.s with
          | DefStmt
              ( { name = EN (Id (id, _)); _ },
                FieldDefColon { vinit = Some e; _ } ) ->
              let t = PI.fake_info (snd id) ":" in
              v_partial ~recurse:false (PartialSingleField (id, t, e))
          | DefStmt (ent, def) -> v_flddef_as_assign_expr ent def
          | _ -> ());
          let v1 = v_stmt v1 in
          ()
    in
    vin.kfield (k, all_functions) x
  and v_fields xs =
    (* As opposed to kstmts, we don't call the visitor for sublists
     * of xs. Indeed, in semgrep, fields are matched in any order
     * so calling the visitor and matcher on the entire list of fields
     * should also work.
     *)
    let k xs = v_list v_field xs in
    vin.kfields (k, all_functions) xs
  and v_type_definition { tbody = v_tbody } =
    let arg = v_type_definition_kind v_tbody in
    ()
  and v_type_definition_kind = function
    | OrType v1 ->
        let v1 = v_list v_or_type_element v1 in
        ()
    | AndType v1 ->
        let v1 = v_bracket v_fields v1 in
        ()
    | AliasType v1 ->
        let v1 = v_type_ v1 in
        ()
    | NewType v1 ->
        let v1 = v_type_ v1 in
        ()
    | Exception (v1, v2) ->
        let v1 = v_ident v1 and v2 = v_list v_type_ v2 in
        ()
    | AbstractType v1 -> v_tok v1
    | OtherTypeKind (v1, v2) ->
        let v1 = v_other_type_kind_operator v1 and v2 = v_list v_any v2 in
        ()
  and v_other_type_kind_operator _x = ()
  and v_or_type_element = function
    | OrConstructor (v1, v2) ->
        let v1 = v_ident v1 and v2 = v_list v_type_ v2 in
        ()
    | OrEnum (v1, v2) ->
        let v1 = v_ident v1 and v2 = v_option v_expr v2 in
        ()
    | OrUnion (v1, v2) ->
        let v1 = v_ident v1 and v2 = v_type_ v2 in
        ()
  and v_class_definition x =
    let k
        {
          ckind = v_ckind;
          cextends = v_cextends;
          cimplements = v_cimplements;
          cmixins = v_mixins;
          cbody = v_cbody;
          cparams;
        } =
      let arg = v_class_kind v_ckind in
      let arg = v_list v_class_parent v_cextends in
      let arg = v_list v_type_ v_cimplements in
      let arg = v_list v_type_ v_mixins in
      v_parameters cparams;
      let arg = v_bracket v_fields v_cbody in
      ()
    in
    vin.kclass_definition (k, all_functions) x
  and v_class_kind (_x, t) = v_tok t
  and v_class_parent (v1, v2) =
    v_type_ v1;
    v_option v_arguments v2
  and v_module_definition { mbody = v_mbody } =
    let arg = v_module_definition_kind v_mbody in
    ()
  and v_module_definition_kind = function
    | ModuleAlias v1 ->
        let v1 = v_dotted_ident v1 in
        ()
    | ModuleStruct (v1, v2) ->
        let v1 = v_option v_dotted_ident v1 and v2 = v_stmts v2 in
        ()
    | OtherModule (v1, v2) ->
        let v1 = v_other_module_operator v1 and v2 = v_list v_any v2 in
        ()
  and v_other_module_operator _x = ()
  and v_macro_definition
      { macroparams = v_macroparams; macrobody = v_macrobody } =
    let arg = v_list v_ident v_macroparams in
    let arg = v_list v_any v_macrobody in
    ()
  and v_directive x =
    let k { d; d_attrs } =
      v_list v_attribute d_attrs;
      match d with
      | ImportFrom (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_module_name v1 in
          let v2 = v_list v_alias v2 in
          ()
      | ImportAs (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_module_name v1 and v2 = v_option v_ident_and_id_info v2 in
          ()
      | ImportAll (t, v1, v2) ->
          let t = v_tok t in
          let v1 = v_module_name v1 and v2 = v_tok v2 in
          ()
      | Package (t, v1) ->
          let t = v_tok t in
          let v1 = v_dotted_ident v1 in
          ()
      | PackageEnd t ->
          let t = v_tok t in
          ()
      | Pragma (v1, v2) ->
          v_ident v1;
          v_list v_any v2
      | OtherDirective (v1, v2) ->
          let v1 = v_todo_kind v1 and v2 = v_list v_any v2 in
          ()
    in
    vin.kdir (k, all_functions) x
  and v_alias (v1, v2) =
    let v1 = v_ident v1 and v2 = v_option v_ident_and_id_info v2 in
    ()
  and v_other_directive_operator _ = ()
  and v_ident_and_id_info (v1, v2) =
    v_ident v1;
    v_id_info v2
  and v_program v = v_stmts v
  and v_any = function
    | Name v1 -> v_name v1
    | Xmls v1 -> v_list v_xml_body v1
    | ForOrIfComp v1 -> v_for_or_if_comp v1
    | Tp v1 -> v_type_parameter v1
    | Ta v1 -> v_type_argument v1
    | Cs v1 -> v_case v1
    | Str v1 -> v_wrap v_string v1
    | Args v1 -> v_list v_argument v1
    | Params v1 -> v_list v_parameter v1
    | Flds v1 -> v_fields v1
    | Anys v1 -> v_list v_any v1
    | Partial v1 -> v_partial ~recurse:true v1
    | TodoK v1 -> v_ident v1
    | Modn v1 ->
        let v1 = v_module_name v1 in
        ()
    | ModDk v1 ->
        let v1 = v_module_definition_kind v1 in
        ()
    | En v1 ->
        let v1 = v_entity v1 in
        ()
    | E v1 ->
        let v1 = v_expr v1 in
        ()
    | S v1 ->
        let v1 = v_stmt v1 in
        ()
    | Ss v1 ->
        let v1 = v_stmts v1 in
        ()
    | T v1 ->
        let v1 = v_type_ v1 in
        ()
    | P v1 ->
        let v1 = v_pattern v1 in
        ()
    | Def v1 ->
        let v1 = v_def v1 in
        ()
    | Dir v1 ->
        let v1 = v_directive v1 in
        ()
    | Fld v1 ->
        let v1 = v_field v1 in
        ()
    | Dk v1 ->
        let v1 = v_def_kind v1 in
        ()
    | Di v1 ->
        let v1 = v_dotted_ident v1 in
        ()
    | Pa v1 ->
        let v1 = v_parameter v1 in
        ()
    | Ce v1 ->
        let v1 = v_catch_exn v1 in
        ()
    | Ar v1 ->
        let v1 = v_argument v1 in
        ()
    | At v1 ->
        let v1 = v_attribute v1 in
        ()
    | Pr v1 ->
        let v1 = v_program v1 in
        ()
    | I v1 ->
        let v1 = v_ident v1 in
        ()
    | Tk v1 ->
        let v1 = v_tok v1 in
        ()
    | Lbli v1 -> v_label_ident v1
  and v_raw_tree x =
    let k (x : raw_tree) =
      match x with
      | Token v -> v_wrap v_string v
      | List v -> (v_list v_raw_tree) v
      | Tuple v -> (v_list v_raw_tree) v
      | Case (v1, v2) ->
          v_string v1;
          v_raw_tree v2
      | Option v -> (v_option v_raw_tree) v
      | Any v -> v_any v
    in
    vin.kraw (k, all_functions) x
  and all_functions x = v_any x in
  all_functions

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

(*****************************************************************************)
(* Extract tokens *)
(*****************************************************************************)

(*s: function [[Lib_AST.extract_info_visitor]] *)
let extract_info_visitor recursor =
  let globals = ref [] in
  let hooks =
    {
      default_visitor with
      kinfo = (fun (_k, _) i -> Common.push i globals);
      kexpr =
        (fun (k, _) x ->
          match x.e with
          (* Ignore the tokens from the expression str is aliased to *)
          | Alias ((_str, t), _e) -> Common.push t globals
          | _ -> k x);
    }
  in
  let vout = mk_visitor hooks in
  recursor vout;
  List.rev !globals

(*e: function [[Lib_AST.extract_info_visitor]] *)

(*s: function [[Lib_AST.ii_of_any]] *)
let ii_of_any any = extract_info_visitor (fun visitor -> visitor any)
  [@@profiling]

(*e: function [[Lib_AST.ii_of_any]] *)

let first_info_of_any any =
  let xs = ii_of_any any in
  let min, _max = Parse_info.min_max_ii_by_pos xs in
  min

(*****************************************************************************)
(* Extract ranges *)
(*****************************************************************************)

(*s: function [[Lib_AST.extract_info_visitor]] *)
let extract_ranges :
    AST_generic.any -> (PI.token_location * PI.token_location) option =
  let ranges = ref None in
  let smaller t1 t2 =
    if compare t1.PI.charpos t2.PI.charpos < 0 then t1 else t2
  in
  let larger t1 t2 =
    if compare t1.PI.charpos t2.PI.charpos > 0 then t1 else t2
  in
  let incorporate_tokens (left, right) =
    match !ranges with
    | None -> ranges := Some (left, right)
    | Some (orig_left, orig_right) ->
        ranges := Some (smaller orig_left left, larger orig_right right)
  in
  let incorporate_token tok =
    if PI.is_origintok tok then
      let tok_loc = PI.unsafe_token_location_of_info tok in
      incorporate_tokens (tok_loc, tok_loc)
  in
  let hooks =
    {
      default_visitor with
      kinfo = (fun (_k, _) i -> incorporate_token i);
      kexpr =
        (fun (k, _) expr ->
          match expr.e_range with
          | None -> (
              let saved_ranges = !ranges in
              ranges := None;
              k expr;
              expr.e_range <- !ranges;
              match saved_ranges with
              | None -> ()
              | Some r -> incorporate_tokens r)
          | Some range -> incorporate_tokens range);
      kstmt =
        (fun (k, _) stmt ->
          match stmt.s_range with
          | None -> (
              let saved_ranges = !ranges in
              ranges := None;
              k stmt;
              stmt.s_range <- !ranges;
              match saved_ranges with
              | None -> ()
              | Some r -> incorporate_tokens r)
          | Some range -> incorporate_tokens range);
    }
  in
  let vout = mk_visitor hooks in
  fun any ->
    vout any;
    let res = !ranges in
    ranges := None;
    res

let range_of_tokens tokens =
  List.filter PI.is_origintok tokens |> PI.min_max_ii_by_pos
  [@@profiling]

let range_of_any_opt any =
  (* Even if the ranges are cached, calling `extract_ranges` to get them
   * is extremely expensive (due to `mk_visitor`). Testing taint-mode
   * open-redirect rule on Django, we spent ~16 seconds computing range
   * info (despite caching). If we bypass `extract_ranges` as we do here,
   * that time drops to just ~1.5 seconds! *)
  match any with
  | G.E e when Option.is_some e.e_range -> e.e_range
  | G.S s when Option.is_some s.s_range -> s.s_range
  | G.Tk tok -> (
      match Parse_info.token_location_of_info tok with
      | Ok tok_loc -> Some (tok_loc, tok_loc)
      | Error _ -> None)
  | G.Anys [] -> None
  | _ -> extract_ranges any
  [@@profiling]
