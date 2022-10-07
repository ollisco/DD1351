% remove duplicate elements from a list
remove_duplicates([],[]).
remove_duplicates([H|T],R) :-
  select(H, T, R1), !,
  remove_duplicates([H|R1],R).

remove_duplicates([H|T],[H|R]) :-
  remove_duplicates(T,R).
  