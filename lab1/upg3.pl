partstring(List, L, F) :-
    subsequence(F, List), 
    length(F, L). % Binds the output length

subsequence([], _).   % s1
subsequence([H|T1], [H|T2]) :- %s2
    subsequence(T1, T2). %s3
subsequence([H|T1], [_|T2]) :-  %s4
    subsequence([H|T1], T2). %s5


%    Call: (10) partstring([1, 2, 3, 4], _69310540, _69310542) ? creep
%    Call: (11) subsequence(_69310542, [1, 2, 3, 4]) ? creep
%    Exit: (11) subsequence([], [1, 2, 3, 4]) ? creep
%    Call: (11) length([], _69310540) ? creep
%    Exit: (11) length([], 0) ? creep
%    Exit: (10) partstring([1, 2, 3, 4], 0, []) ? creep
% L = 0,
% F = [] ;

% Bind X till Head av den givna listan (1) och sätt det föst i F {S2}
%    Redo: (11) subsequence(_69310542, [1, 2, 3, 4]) ? creep  #
% Kalla på subsequence igen med båda svansarna. {S3}
%    Call: (12) subsequence(_69318110, [2, 3, 4]) ? creep
% T1 är en virabel (_69318110) och binder till den tomma listan. {S1}
% T2 matchar _ och fortsätter vara sann. {S1}
% Vi callarn inte subsequence här igen. {S1}
%    Exit: (12) subsequence([], [2, 3, 4]) ? creep
% Vi exitar även här och sätter på T2 ([]) på X (1) och returnar
%    Exit: (11) subsequence([1], [1, 2, 3, 4]) ? creep
% -----
%    Call: (11) length([1], _69310540) ? creep
%    Exit: (11) length([1], 1) ? creep
%    Exit: (10) partstring([1, 2, 3, 4], 1, [1]) ? creep
% L = 1,
% F = [1] ;