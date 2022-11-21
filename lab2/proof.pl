% Olle Jernström & Marcus Bardvall 		    
% Labb 2 - 2022-11-21						

verify(InputFileName) :- see(InputFileName),
	read(Premise), read(Goal), read(Proof),
	seen,
	valid_proof(Premise, Goal, Proof).

valid_proof(Premise, Goal, Proof):- 
	check_goal(Goal, Proof),
	check_proof(Premise, Proof, []), !.

% Check Goal		    

check_goal(Goal, Proof):- 
	last(Proof, LastLine),
	nth1(2, LastLine, Goal).
	
% Check Proof 

check_proof(_, [], _).
check_proof(Premise, [H|T], VerifiedList):- 
	check_rule(Premise, H, VerifiedList),
	add_to_list(H, VerifiedList, NewList),
	check_proof(Premise, T, NewList).
	
% Check Rules

%% Check if it is a premise
check_rule(Premise, [_, A, premise], _):-
	member(A, Premise).	

%% andint(X,Y)
check_rule(_, [_, and(A1,A2), andint(X,Y)], VerifiedList):-
	member([X, A1, _], VerifiedList),
	member([Y, A2, _], VerifiedList).

%% orint1(X)
check_rule(_,[_,or(A,_), orint1(Z)], VerifiedList):-
	member([Z,A,_], VerifiedList).

%% orint2(X)
check_rule(_,[_,or(_,A), orint2(Z)], VerifiedList) :-
	member([Z,A,_], VerifiedList).

%% andel1         
check_rule(_, [_, A, andel1(X)],VerifiedList):-
	member([X, and(A,_), _], VerifiedList).

%% andel2 
check_rule(_, [_, A, andel2(X)],VerifiedList):-
	member([X, and(_,A), _],VerifiedList).

%% impel(x,y)
check_rule(_, [_, A, impel(X,Y)],VerifiedList):-
    member([X, A1,_],VerifiedList),
	member([Y, imp(A1,A),_],VerifiedList).

%% lem
check_rule(_, [_,or(A, neg(A)), lem],_).


%% copy(x)
check_rule(_,[_,A, copy(X)],VerifiedList):-
	member([X,A,_],VerifiedList).

%% negel(x)
check_rule(_,[_,cont, negel(X,Y)], VerifiedList):-
	member([X, A,_], VerifiedList),
	member([Y, neg(A),_], VerifiedList).

%% mt(x,y) 
check_rule(_,[_, neg(A), mt(X,Y)], VerifiedList):-
	member([X,imp(A,neg(A2)),_], VerifiedList),
	member([Y,neg(neg(A2)),_], VerifiedList);

	member([X,imp(A,A2),_], VerifiedList),
	member([Y,neg(A2),_], VerifiedList).

%% mt(x,y) but with double negation
check_rule(_,[_,neg(neg(A)), mt(X,Y)], VerifiedList):-
	member([X,imp(neg(A,A2)),_], VerifiedList),
	member([Y,neg(A2),_], VerifiedList);

	member([X,imp(neg(A,neg(A2))),_], VerifiedList),
	member([Y,neg(neg(A2)),_], VerifiedList).

%% negnegint(x)
check_rule(_,[_, neg(neg(A)), negnegint(X)], VerifiedList):-
	member([X, A,_], VerifiedList).

%% negnegel(x)
check_rule(_,[_,A, negnegel(X)], VerifiedList):-
	member([X, neg(neg(A)),_], VerifiedList).

%% contel(x)
check_rule(_, [_, _, contel(X)], VerifiedList):-
	member([X, cont, _], VerifiedList).


% Hanbdling boxes
%% Checks the box and calls check_proof which then recursively iterates through the box
check_rule(Premise, [[X, A, assumption]|T], VerifiedList):-
	add_to_list([X, A, assumption], VerifiedList, NewList),
	check_proof(Premise,T,NewList).
	
%%n negint
check_rule(_, [_, neg(A), negint(X,Y)], VerifiedList):-
	member(BoxList, VerifiedList),
	member([X, A, assumption], BoxList),
	member([Y, cont, _], BoxList).

%% impint
check_rule(_, [_, imp(A1,A2), impint(X,Y)], VerifiedList):-
	member(BoxList, VerifiedList),
	member([X, A1, assumption], BoxList),
	member([Y, A2, _], BoxList).

%% pbc
check_rule(_, [_, A, pbc(X,Y)], VerifiedList):-
	member(BoxList, VerifiedList),
	member([X, neg(A), assumption], BoxList),
	member([Y, cont, _], BoxList).

%% or-elimination: orel(x,y,u,v,w)
check_rule(_, [_, A, orel(S1,S2,S3,S4,S5)], VerifiedList):-
	member(BoxList1, VerifiedList),
	member(BoxList2, VerifiedList),
	member([S1, or(A1,A2),_], VerifiedList),
	member([S2, A1, assumption], BoxList1),
	member([S3,A, _], BoxList1),
	member([S4,A2, assumption], BoxList2),
	member([S5,A, _], BoxList2).

% List handling

% Add to list
add_to_list(H, VerifiedList, NewList):-
	appendEl(H, VerifiedList, NewList).
     
% Add to the back
appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]):-
	appendEl(X, T, Y).