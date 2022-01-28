:-  [axiom_pinpointing].
:- 	[prover].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%	Main.pl
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load_ontology/0
% loadontology(+Files:list)
load_ontology(Files) :- load_ontology_files(Files, []).

%% check_entailment/2
% check_entailment(+Ontology, +Consequence)
check_entailment(A) :- entails(A).

%% get_a_just/3
% get_a_just(+Ontology, +Consequence, -A_Justification)
get_a_just(O, A, R) :- entails(A), minimize(O, A, [], J), readible_ajust(J, [], R).

%% get_all_just/3
% get_all_just(+Ontology, +Consequence, -All_Justifications)
% Queue in compute_justifications_HST/4 starts with H(v_0) = first computed justification
get_all_just(O, A, R) :- entails(A), compute_justifications_HST(O, A, [], [], J), readible_alljust(J, [], R).
