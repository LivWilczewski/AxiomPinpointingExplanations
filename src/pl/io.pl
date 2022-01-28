:- use_module(library(listing)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Load a file of Prolog terms as dynamic predicates.
%% Store them all as clauses in a list.
%% Manipulation of clauses.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% Dynamic predicates manipulation
%%

%% rule/3
% rule(?Rule, ?Head, ?Body)
rule(R, Head, Body) :- R = (Head :- Body).

%% change_ontology/2
% change_ontology(+OldOntology, -NewOntology)
change_ontology(O, R) :- assertz(ontology(R)), retract(ontology(O)).

%% remove_clause/3
% remove_clause(+Clause, +Ontology, -Result)
remove_clause(C, O, R) :- 
		clause(H, B, _) = C, nonvar(B), rule(P, H, B), 
		delete(O, C, R), retract(P). %, change_ontology(O, R).
remove_clause(C, O, R) :- 
		clause(H, _, _) = C,  
		delete(O, C, R), retract(H). %, change_ontology(O, R).
		
%% add_clause/3
% add_clause(+Clause, +Ontology, -Result)
% only invoked when backtracking the retract in minimize 
% -> reasserted as first clause (original place) of the predicate.
add_clause(C, O, R) :- 
		clause(H, B, _) = C, nonvar(B), rule(P, H, B), asserta(P), 
		union([C], O, R). %, change_ontology(O, R).
add_clause(C, O, R) :- 
		clause(H, _, _) = C, asserta(H), 
		union([clause(H, _, _)], O, R). %, change_ontology(O, R).
		
%% remove_clauses/3
% remove_clauses(+Clauses, +Ontology, -Result)
% TODO: test
remove_clauses([], O, R) :- R = O.
remove_clauses([C|Tail], O, R) :- remove_clause(C, O, ONew), remove_clauses(Tail, ONew, R).

%% add_clauses/3
% add_clauses(+Clauses, +Ontology, -Result)
% TODO: test
add_clauses([], O, R) :- R = O.
add_clauses([C|Tail], O, R) :- add_clause(C, O, ONew), add_clauses(Tail, ONew, R).

%% transform_to_clause/2
% transform_to_clause(+Predicate, -Clause)
transform_to_clause(P, C) :- rule(P, H, B), clause(H, B, R), C = clause(H, B, R).
transform_to_clause(P, C) :- \+rule(P, _, _), clause(P, _, R), C = clause(P, _, R).

%% transform_to_axiom/2
% transform_to_axiom(+Clause, -Axiom)
transform_to_axiom(C, A) :- clause(H, B, _) = C, nonvar(B), rule(P, H, B), A = P.
transform_to_axiom(C, A) :- clause(H, _, _) = C, A = H.

%% readible_alljust/2
% readible_alljust(+Clauses, Set, -Result)
readible_alljust([], S, R) :- R = S.
readible_alljust([J|Tail], S, R) :- readible_ajust(J, [], JR), append(S, [JR], SJ), readible_alljust(Tail, SJ, R).

%% readible_ajust/2
% readible_ajust(+Clauses, Set, -Result)
readible_ajust([], S, R) :- R = S.
readible_ajust([C|Tail], S, R) :- transform_to_axiom(C, A), append(S, [A], SA), readible_ajust(Tail, SA, R).

%%
%% Reload Ontology without file
%%

%% reload_ontology/1
% reload_ontology(+Ontology)
reload_ontology([]) :- !.
reload_ontology([C|Tail]) :- reassert_ontology(C), reload_ontology(Tail).

%% reassert_ontology/1
% reassert_ontology(+Clause)
reassert_ontology(C):-  clause(H, B, _) = C, nonvar(B), rule(P, H, B), retract(P), assertz(P).
reassert_ontology(C):-  clause(H, B, _) = C, nonvar(B), rule(P, H, B), assertz(P).
reassert_ontology(C) :- clause(H, _, _) = C, retract(H), assertz(H).
reassert_ontology(C) :- clause(H, _, _) = C, assertz(H).

%%
%% Loading files
%%

%% load_ontology_files/2
%% load_ontology_files(+Filelist, -Ontology)
load_ontology_files([], []) :- fail.
load_ontology_files([], O) :- assertz(ontology(O)), listing.
load_ontology_files([File|Tail], []) :- file_to_list(File, O), load_ontology_files(Tail, O).
load_ontology_files([File|Tail], O) :- file_to_list(File, S), union(O, S, OS), load_ontology_files(Tail, OS).

%% file_to_list/2
% file_to_list(+Filename, -Resultlist)
% File: 'filename.pl'
file_to_list(FILE, LIST) :- see(FILE), 
   inquire([], R), 							% gather terms from file
   reverse(R, LIST),
   seen.

%% inquire/2
% inquire(+Inputlist, -Outputlist)
% asserts new clauses as last clause of the predicate. 
inquire(IN, OUT):- 
		read(Data), 
		(Data == end_of_file -> 
			OUT = IN; 
			(assertz(Data), transform_to_clause(Data, C), 
				union([C], IN, In),	inquire(In, OUT))).