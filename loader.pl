/* 
=========================================================
   CHARGEMENT ET VALIDATION DU GRAPHE
=========================================================
*/

/*
------------------------------------------------------------
load_graph(+File)

Charge un fichier d’entrée décrivant un graphe orienté capacitaire,
vérifie la validité syntaxique et la cohérence élémentaire des données,
puis insère les faits en base.

Paramètre :
+File : fichier d’entrée contenant les termes Prolog décrivant
        les sommets, les arêtes, la source et le puits
*/
load_graph(File) :-
    read_terms(File, Terms),
    maplist(is_valid, Terms),
    include(is_edge, Terms, Edges),
    include(is_node2, Terms, Nodes),
    graph_correcte(Edges, Nodes),
    maplist(assertz, Terms).


/*
------------------------------------------------------------
graph_correcte(+Edges, +Nodes)

Vérifie la cohérence élémentaire du graphe :
- il existe exactement une source ;
- il existe exactement un puits ;
- la source et le puits sont distincts ;
- toute arête relie deux sommets déclarés.

Paramètres :
+Edges : liste des arêtes du graphe, sous la forme edge(X,Y,C)
+Nodes : liste des sommets déclarés, y compris node(X), source(X) et sink(X)
*/
graph_correcte(Edges, Nodes) :-
    unique_source(Nodes, Source),
    unique_sink(Nodes, Sink),
    Source \== Sink,
    edges_correctes(Edges, Nodes).


/*
------------------------------------------------------------
unique_source(+Nodes, -Source)

Vrai s’il existe exactement une source dans la liste des sommets déclarés.
*/
unique_source(Nodes, Source) :-
    findall(X, member(source(X), Nodes), Sources),
    Sources = [Source].

/*
------------------------------------------------------------
unique_sink(+Nodes, -Sink)

Vrai s’il existe exactement un puits dans la liste des sommets déclarés.
*/
unique_sink(Nodes, Sink) :-
    findall(X, member(sink(X), Nodes), Sinks),
    Sinks = [Sink].

/*
------------------------------------------------------------
edges_correctes(+Edges, +Nodes)

Vérifie que chaque arête relie bien deux sommets existants.
*/
edges_correctes([], _).

edges_correctes([edge(X,Y,_)|T], Nodes) :-
    node_present(X, Nodes),
    node_present(Y, Nodes),
    edges_correctes(T, Nodes).

/*
------------------------------------------------------------
node_present(+Sommet, +Nodes)

Vrai si le sommet est déclaré soit comme sommet ordinaire,
soit comme source, soit comme puits.
*/
node_present(X, Nodes) :-
    member(node(X), Nodes);
    member(source(X), Nodes);
    member(sink(X), Nodes).


/*
------------------------------------------------------------
is_valid(+Term)

Vérifie qu’un terme lu dans le fichier d’entrée appartient
au format attendu par le projet.
*/
is_valid(Term) :-
    is_edge(Term);
    is_node2(Term);
    is_source(Term);
    is_sink(Term).

is_valid(Term) :-
    write('Non valide: '), write(Term), nl,
    fail.


/*
------------------------------------------------------------
is_edge(+Term)

Vrai si le terme décrit une arête valide du graphe :
- deux sommets atomiques ;
- une capacité numérique ;
- une capacité positive ou nulle.
*/
is_edge(edge(X, Y, C)) :-
    atom(X),
    atom(Y),
    number(C),
    C >= 0.


/*
------------------------------------------------------------
is_node2(+Term)

Reconnaît tout terme représentant un sommet du graphe,
qu’il s’agisse d’un sommet ordinaire, de la source ou du puits.
*/
is_node2(Term) :-
    is_node1(Term);
    is_sink(Term);
    is_source(Term).

/*
------------------------------------------------------------
is_node1(+Term)

Vrai si le terme décrit un sommet ordinaire.
*/
is_node1(node(X)) :-
    atom(X).

/*
------------------------------------------------------------
is_source(+Term)

Vrai si le terme décrit la source du réseau de flot.
*/
is_source(source(X)) :-
    atom(X).

/*
------------------------------------------------------------
is_sink(+Term)

Vrai si le terme décrit le puits du réseau de flot.
*/
is_sink(sink(X)) :-
    atom(X).


/* 
=========================================================
   LECTURE DU FICHIER D’ENTRÉE
=========================================================
*/

/*
------------------------------------------------------------
read_terms(+File, -Terms)

Lit tous les termes Prolog présents dans le fichier d’entrée.
*/
read_terms(File, Terms) :-
    open(File, read, Stream),
    read_all_terms(Stream, Terms),
    close(Stream).

/*
------------------------------------------------------------
read_all_terms(+Stream, -Terms)

Lit récursivement tous les termes du flux jusqu’à la fin du fichier.
*/
read_all_terms(Stream, []) :-
    at_end_of_stream(Stream).

read_all_terms(Stream, [Term|Rest]) :-
    \+ at_end_of_stream(Stream),
    read(Stream, Term),
    read_all_terms(Stream, Rest).