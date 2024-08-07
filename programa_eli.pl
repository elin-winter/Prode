%resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais).
resultado(paises_bajos, 3, estados_unidos, 1). % Paises bajos 3 - 1 Estados unidos
resultado(australia, 1, argentina, 2). % Australia 1 - 2 Argentina
resultado(polonia, 3, francia, 1).
resultado(inglaterra, 3, senegal, 0).

pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).
pronostico(gus, gano(estados_unidos, paises_bajos, 1 , 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1 , 0)).

% ------------------- Puntos ---------------------
% ----------- Punto 1
% Parte A

jugaron(Pais1, Pais2, Diferencia):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Diferencia is Goles1 - Goles2.

jugaron(Pais1, Pais2, Diferencia):-
    resultado(Pais2, Goles2, Pais1, Goles1),
    Diferencia is Goles2 - Goles1.

% Parte B

leGano(Ganador, Perdedor):-
    resultado(Ganador, Goles1, Perdedor, Goles2),
    Goles1 > Goles2.

leGano(Ganador, Perdedor):-
    resultado(Perdedor, Goles1, Ganador, Goles2),
    Goles2 > Goles1.

% ----------- Punto 2

% Primer Caso: Predicción exacta
puntosPronostico(gano(Ganador, Perdedor, GolesG, GolesP), 200) :-
    resultado(Ganador, GolesG, Perdedor, GolesP),
    leGano(Ganador,Perdedor).

puntosPronostico(gano(Ganador, Perdedor, GolesG, GolesP), 200) :-
    resultado(Perdedor, GolesP, Ganador, GolesG), 
    leGano(Ganador,Perdedor).

puntosPronostico(empataron(Pais1, Pais2, Goles), 200) :-
    resultado(Pais1, Goles, Pais2, Goles).

puntosPronostico(empataron(Pais1, Pais2, Goles), 200) :-
    resultado(Pais2, Goles, Pais1, Goles).

% Segundo Caso: Predicción del ganador o empate, pero no goles
puntosPronostico(gano(Ganador, Perdedor, _, _), 100) :-
    leGano(Ganador, Perdedor).

puntosPronostico(empataron(Pais1, Pais2, _), 100) :-
    resultado(Pais1, Goles, Pais2, Goles).

puntosPronostico(empataron(Pais1, Pais2, _), 100) :-
    resultado(Pais2, Goles, Pais1, Goles).

% Tercer Caso: Predicción incorrecta
puntosPronostico(gano(Ganador, Perdedor, _, _), 0) :-
    jugaron(Ganador,Perdedor,_),
    not(leGano(Ganador, Perdedor)).

puntosPronostico(empataron(Pais1, Pais2, _), 0) :-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Goles1 \= Goles2.

puntosPronostico(empataron(Pais1, Pais2, _), 100) :-
    resultado(Pais2, Goles2, Pais1, Goles1),
    Goles1 \= Goles2.

% ----------- Punto 3

invicto(Jugador) :- 
    pronostico(Jugador, _),
    findall(Puntaje, 
        (pronostico(Jugador, Pronostico), 
        puntosPronostico(Pronostico, Puntaje)),
        Puntajes),
    Puntajes \= [],
    forall(member(Puntos, Puntajes), Puntos >= 100).   

% ----------- Punto 4
puntaje(Jugador, PuntajeTotal) :-
    pronostico(Jugador, _), 
    findall(Puntaje, (pronostico(Jugador, Pronostico), puntosPronostico(Pronostico, Puntaje)), Puntajes),
    sumlist(Puntajes, PuntajeTotal).

% ----------- Punto 5
favorito(Pais) :-
    pronostico(_, gano(Pais,_,_,_)),
    not(forall(pronostico(_,Pronostico), (Pronostico \= gano(_,Pais,_,_) , Pronostico \= empato(Pais,_,_), Pronostico \= empato(_,Pais,_)))).

% El país ganó todos sus partidos por goleada (>= 3 goles de diferencia)
favorito(Pais) :-
    forall(leGano(Pais, _), (jugaron(Pais, _, Diferencia), Diferencia >= 3)).
