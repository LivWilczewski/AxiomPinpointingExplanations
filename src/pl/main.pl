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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%	Time measures
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% measure_load_ontology/0
% measure_load_ontology(+Files:list)
measure_load_ontology(Files) :- statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
   	load_ontology_files(Files, []),
   	statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
   	write('Execution took '), write(ExecutionTime), write(' ms.'), nl.
   	
%% measure_check_entailment/2
% measure_check_entailment(+Ontology, +Consequence)
measure_check_entailment(A) :- statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
   	entails(A),
   	statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
   	write('Execution took '), write(ExecutionTime), write(' ms.'), nl.

%% measure_get_a_just/3
% measure_get_a_just(+Ontology, +Consequence, -A_Justification)
measure_get_a_just(O, A, R) :- statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
   	entails(A), minimize(O, A, [], R),
   	statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
   	write('Execution took '), write(ExecutionTime), write(' ms.'), nl.
   	
%% measure_get_all_just/3
% measure_get_all_just(+Ontology, +Consequence, -All_Justifications)
measure_get_all_just(O, A, R) :- statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
   	entails(A), compute_justifications_HST(O, A, [], [], R),
   	statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
   	write('Execution took '), write(ExecutionTime), write(' ms.'), nl.
   	
%% measure_prove/1
% measure_prove(+Consequence)
measure_prove(A) :- statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
   	prove_p(A),
   	statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
   	write('Execution took '), write(ExecutionTime), write(' ms.'), nl.
