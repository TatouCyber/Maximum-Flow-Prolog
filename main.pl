:- consult('loader.pl').

run :-
    read_terms('graph.pl',T),
    write(T),nl.
