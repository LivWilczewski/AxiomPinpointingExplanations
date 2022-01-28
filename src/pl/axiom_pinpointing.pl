:-  [io].
:- use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Axiom Pinpointing
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% entailment
%%

%% entails/2
% entails(+Justification, +Consequence)
entails(A) :- clause(H, _, _) = A, call(H).

%%
%% a-just
%%

%% minimize/3
% minimize(+Ontology, +Consequence, -A_Justification)
% minimize([], _A, [], []) :- ontology(O), fail, !.
minimize([], A, J, R) :- entails(A), ontology(O), reload_ontology(O), R = J.
minimize([B|O], A, [], R) :- 
		remove_clause(B, O, ONew), 
		(entails(A) -> 
			(minimize(ONew, A, [], R)); 
			(add_clause(B, ONew, _), append([], [B], Set), 
				minimize(ONew, A, Set, R))).
minimize([B|O], A, J, R) :- 
		remove_clause(B, O, ONew),  
		(entails(A) -> 
			(minimize(ONew, A, J, R)); 
			(add_clause(B, ONew, _), append(J, [B], Set), 
				minimize(ONew, A, Set, R))).

%%
%% all-just
%%

%% compute_justifications_HST/4
% compute_justifications_HST(+Ontology, +Consequence, +Queue, Set, -All_Justifications)
compute_justifications_HST(O, A, [], [], R) :- 
		minimize(O, A, [], J),  
		compute_Q([], J, [], Q), union([], [J], S), 
		compute_justifications_HST(O, A, Q, S, R).
compute_justifications_HST(O, A, [Node|Tail], S, R) :- 
		remove_clauses(Node, O, ONew), 
		(entails(A) -> (minimize(ONew, A, [], J), ontology(O1), 
			compute_Q(Node, J, [], Q), union(Q, Tail, Queue), union(S, [J], SSet), 
			compute_justifications_HST(O1, A, Queue, SSet, R));
			(add_clauses(Node, O, O2),  
			compute_justifications_HST(O2, A, Tail, S, R))).
compute_justifications_HST(_O, _A, _Q, S, R) :- 
		R = S.

%% compute_Q/3
% compute_Q(+Node, +Justification, Queue, -Queueresult)
compute_Q(_H, [], Q, QR) :- QR = Q.
compute_Q(H, [B|Tail], Q, QR) :- union(H, [B], HBSet), union(Q, [HBSet], Queue), compute_Q(H, Tail, Queue, QR).