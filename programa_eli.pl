%resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais).
resultado(paises_bajos, 5, estados_unidos, 1). % Paises bajos 3 - 1 Estados unidos
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

pais(Pais):-
    resultado(Pais, _, _, _).

pais(Pais):-
    resultado(_, _, Pais, _).

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
    forall((
        pronostico(Jugador, Pronostico), 
        puntosPronostico(Pronostico, Puntaje)), 
        Puntaje >= 100).

% ----------- Punto 4
puntaje(Jugador, PuntajeTotal) :-
    pronostico(Jugador, _), 
    findall(Puntaje, (pronostico(Jugador, Pronostico), puntosPronostico(Pronostico, Puntaje)), Puntajes),
    sumlist(Puntajes, PuntajeTotal).

% ----------- Punto 5
favorito(Pais) :-
    pais(Pais),
    leGano(Pais, _),
    forall(partidoGanado(Pais, Diferencia),
        ganoPorGoleada(Diferencia)).

favorito(Pais):-
    pais(Pais),
    pronostico(_, gano(Pais,_,_,_)),
    forall(
        pronosticoPais(Pronostico, Pais), 
        esGanador(Pronostico, Pais)).

pronosticoPais(Pronostico, Pais):-
    pronostico(_, Pronostico),
    pronosticoDelPais(Pronostico, Pais).

pronosticoDelPais(gano(Pais, _, _, _), Pais).
pronosticoDelPais(gano(_, Pais, _, _), Pais).
pronosticoDelPais(empataron(Pais, _, _), Pais).
pronosticoDelPais(empataron(_, Pais, _), Pais).

esGanador(gano(Pais, _, _, _), Pais).

partidoGanado(Pais, Diferencia):-
    leGano(Pais, Otro),
    jugaron(Pais, Otro, Dif),
    abs(Dif, Diferencia).

ganoPorGoleada(Diferencia):-
    Diferencia >= 3.