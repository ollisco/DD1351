# Lab 1
## Uppgift 1

<h3>
Betrakta denna fråga till ett Prologsystem:

?- T=f(a,Y,Z), T=f(X,X,b).

Vilka bindningar presenteras som resultat?

Ge en kortfattad förklaring till ditt svar!
</h3>
Dessa bindingar presenteras i resultat:
T = f(a, a, b),
Y = X, X = a,
Z = b.

Förklaring: T är en variabel som är bunden till f(a,Y,Z). T är också bunden till f(X,X,b). Detta innebär att X binder till a och Y binder till X. Z är bunden till b.

## Uppgift 2
<h3>
En lista är en representation av sekvenser där 
den tomma sekvensen representeras av symbolen []
och en sekvens bestående av tre heltal 1 2 3 
representeras av [1,2,3] eller i kanonisk syntax '.'(1,'.'(2,'.'(3,[])))

Den exakta definitionen av en lista är:

list([]).
list([H|T]) :- list(T).


Vi vill definiera ett  predikat som givet en lista som 
representerar en sekvens skapar en annan lista som innehåller
alla element som förekommer i inlistan i samma ordning, men 
om ett element har fōrekommit tidigare i listan skall det 
inte vara med i den resulterande listan.

Till exempel: 

?- remove_duplicates([1,2,3,2,4,1,3,4], E).

skall generera E=[1,2,3,4]

Definiera alltså predikatet remove_duplicates/2!
Förklara varför man kan kalla detta predikat för en funktion!
</h3>


```pl
remove_duplicates([],[]).
remove_duplicates([H|T],R) :-
  select(H, T, R1), !,
  remove_duplicates([H|R1],R).

remove_duplicates([H|T],[H|R]) :-
  remove_duplicates(T,R).
```

