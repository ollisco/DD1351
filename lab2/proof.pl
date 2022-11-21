% Olle Jernström & Marcus Bardvall 		    
% Labb 2 - 2022-11-21						

verify(InputFileName) :- see(InputFileName),
	read(Prems), read(Goal), read(Proof),
	seen,
	valid_proof(Prems, Goal, Proof).

valid_proof(Prems, Goal, Proof):- 
	check_goal(Goal, Proof),
	check_proof(Prems, Proof, []), !.

% Check Goal		    

check_goal(Goal, Proof):- 
	last(Proof, LastRow),
	nth1(2, LastRow, Goal).
	

% Check Proof 

check_proof(_, [], _).
check_proof(Prems, [H|T], CheckedList):- 
	check_rule(Prems, H, CheckedList),
	add_to_list(H, CheckedList, NewList),
	check_proof(Prems, T, NewList).
	
% Check Rules

%% Check if it is a premise
check_rule(Prems, [_, Atom, premise], _):-
	member(Atom, Prems).	

%% andint(X,Y)
check_rule(_, [_, and(Atom1,Atom2), andint(X,Y)], CheckedList):-
	member([X, Atom1, _], CheckedList),
	member([Y, Atom2, _], CheckedList).

%% orint1(X)
check_rule(_,[_,or(Atom,_), orint1(Z)], CheckedList):-
	member([Z,Atom,_], CheckedList).

%% orint2(X)
check_rule(_,[_,or(_,Atom), orint2(Z)], CheckedList) :-
	member([Z,Atom,_], CheckedList).

%% andel1         
check_rule(_, [_, Atom, andel1(X)],CheckedList):-
	member([X, and(Atom,_), _], CheckedList).

%% andel2 
check_rule(_, [_, Atom, andel2(X)],CheckedList):-
	member([X, and(_,Atom), _],CheckedList).

%% impel(x,y)
check_rule(_, [_, Atom, impel(X,Y)],CheckedList):-
    member([X, Atom1,_],CheckedList),
	member([Y, imp(Atom1,Atom),_],CheckedList).

%% lem
check_rule(_, [_,or(Atom, neg(Atom)), lem],_).


%% copy(x)
check_rule(_,[_,Atom, copy(X)],CheckedList):-
	member([X,Atom,_],CheckedList).

%% negel(x)
check_rule(_,[_,cont, negel(X,Y)], CheckedList):-
	member([X, Atom,_], CheckedList),
	member([Y, neg(Atom),_], CheckedList).

%% mt(x,y) 
check_rule(_,[_, neg(Atom), mt(X,Y)], CheckedList):-
	member([X,imp(Atom,neg(Atom2)),_], CheckedList),
	member([Y,neg(neg(Atom2)),_], CheckedList);

	member([X,imp(Atom,Atom2),_], CheckedList),
	member([Y,neg(Atom2),_], CheckedList).

%% mt(x,y) but with double negation
check_rule(_,[_,neg(neg(Atom)), mt(X,Y)], CheckedList):-
	member([X,imp(neg(Atom,Atom2)),_], CheckedList),
	member([Y,neg(Atom2),_], CheckedList);

	member([X,imp(neg(Atom,neg(Atom2))),_], CheckedList),
	member([Y,neg(neg(Atom2)),_], CheckedList).

%% negnegint(x)
check_rule(_,[_, neg(neg(Atom)), negnegint(X)], CheckedList):-
	member([X, Atom,_], CheckedList).

%% negnegel(x)
check_rule(_,[_,Atom, negnegel(X)], CheckedList):-
	member([X, neg(neg(Atom)),_], CheckedList).

%% contel(x)
check_rule(_, [_, _, contel(X)], CheckedList):-
	member([X, cont, _], CheckedList).


% Hanbdling boxes
%% Checks the box and calls check_proof which then recursively iterates through the box
check_rule(Prems, [[X, Atom, assumption]|T], CheckedList):-
	add_to_list([X, Atom, assumption], CheckedList, NewList),
	check_proof(Prems,T,NewList).
	
%%n negint
check_rule(_, [_, neg(Atom), negint(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, Atom, assumption], BoxList),
	member([Y, cont, _], BoxList).

%% impint
check_rule(_, [_, imp(Atom1,Atom2), impint(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, Atom1, assumption], BoxList),
	member([Y, Atom2, _], BoxList).

%% pbc
check_rule(_, [_, Atom, pbc(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, neg(Atom), assumption], BoxList),
	member([Y, cont, _], BoxList).

%% or-elimination: orel(x,y,u,v,w)
check_rule(_, [_, Atom, orel(S1,S2,S3,S4,S5)], CheckedList):-
	member(BoxList1, CheckedList),
	member(BoxList2, CheckedList),
	member([S1, or(Atom1,Atom2),_], CheckedList),
	member([S2, Atom1, assumption], BoxList1),
	member([S3,Atom, _], BoxList1),
	member([S4,Atom2, assumption], BoxList2),
	member([S5,Atom, _], BoxList2).

% List handling

% Add to list
add_to_list(H, CheckedList, NewList):-
	appendEl(H, CheckedList, NewList).
     
% Lägger in längst bak i nya listan
appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]):-
	appendEl(X, T, Y).