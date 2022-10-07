%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 4       (8p)
% representation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Du skall definiera ett program som arbetar med grafer.

% Föreslå en representation av grafer så att varje nod har ett 
% unikt namn (en konstant) och grannarna finns indikerade. 

% Definiera ett predikat som med denna representation och utan 
% att fastna i en loop tar fram en väg som en lista av namnen på 
% noderna i den ordning de passeras när man utan att passera 
% en nod mer än en gång går från nod A till nod B!
% Finns det flera möjliga vägar skall de presenteras 
% en efter en, om man begär det.

reverse([], []).
reverse([H|T], R) :-
    reverse(T, R1),
    append(R1, [H], R).

solve(Node, Goal, Solution)  :-
    depthfirst([], Node, Goal, R),
    reverse(R, Solution).


depthfirst(Path, Node, Goal, [Node | Path] )  :-
    Node == Goal.

depthfirst(Path, Node, Goal, Sol)  :-
    edge(Node, Node1),
    \+ member(Node1, Path),                % Prevent a cycle
    depthfirst([Node | Path], Node1, Goal, Sol).


edge(a,b).
edge(a,c).
edge(b,d).
edge(b,e).
edge(c,f).
edge(c,g).
edge(d,h).
edge(e,i).
edge(e,j).






