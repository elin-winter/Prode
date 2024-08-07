
% Aquí va el código.

%Base de conocimientos

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

jugador(Jugador):-
    pronostico(Jugador, _).

pais(Pais):-
    simetriaPaises(Pais, _, _, _).

%Punto 1

%Parte a
jugaron(Pais1, Pais2, DiferenciaGoles):-
    simetriaPaises(Pais1, Pais2, Goles1, Goles2),
    DiferenciaGoles is Goles1 - Goles2.

simetriaPaises(Pais1, Pais2, Goles1, Goles2):-
    resultado(Pais1, Goles1, Pais2, Goles2).

simetriaPaises(Pais2, Pais1, Goles1, Goles2):-
    resultado(Pais2, Goles2, Pais1, Goles1).

%Parte b

gano(PaisGanador, PaisPerdedor):-
    definirGanador(PaisGanador, PaisPerdedor).

definirGanador(PaisGanador, PaisPerdedor) :-
    resultado(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor),
    GolesGanador > GolesPerdedor.

definirGanador(PaisGanador, PaisPerdedor) :-
    resultado(PaisPerdedor, GolesPerdedor, PaisGanador, GolesGanador),
    GolesGanador > GolesPerdedor.


% Punto 2
puntosPronostico(Pronostico, Puntos):-
    pronostico(_, Pronostico),
    calcularPuntos(Pronostico, Puntos).

calcularPuntos(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 200):-
    gano(PaisGanador, PaisPerdedor),
    acertoGoles(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor).

calcularPuntos(empate(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 200):-
    empate(PaisGanador, PaisPerdedor),
    acertoGoles(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor).

calcularPuntos(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor),100):-
    gano(PaisGanador, PaisPerdedor),
    not(acertoGoles(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor)).

calcularPuntos(empate(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 100):-
    empate(PaisGanador, PaisPerdedor),
    not(acertoGoles(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor)).

calcularPuntos(empate(PaisGanador, PaisPerdedor, _, _), 0):-
    not(empate(PaisGanador, PaisPerdedor)).

calcularPuntos(gano(PaisGanador, PaisPerdedor, _, _),0):-
    not(gano(PaisGanador, PaisPerdedor)).

empate(Pais1, Pais2):-
    simetriaPaises(Pais1, Goles1, Pais2, Goles2),
    Goles1 = Goles2.

acertoGoles(Pais1, Pais2, Goles1, Goles2):-
    simetriaPaises(Pais1, Pais2, GolesP1, GolesP2),
    GolesP1 = Goles1,
    GolesP2 = Goles2.

%Punto 3

invicto(Jugador):-
    jugador(Jugador),
    findall(Punto, pronosticoPartidoJugado(Jugador, Punto), Puntos),
    Puntos \= [],
    forall(member(Punto, Puntos), Punto > 100).


pronosticoPartidoJugado(Jugador, Puntos):-
    pronostico(Jugador, Pronostico),
    seJugoPartido(Pronostico),
    puntosPronostico(Pronostico, Puntos).
    

seJugoPartido(gano(Pais1, Pais2, _, _)):-
    simetriaPaises(Pais1, Pais2, _, _).

seJugoPartido(empate(Pais1, Pais2, _, _)):-
    simetriaPaises(Pais1, Pais2, _, _).

% Punto 4

puntaje(Jugador, PuntosTotales):-
    jugador(Jugador),
    findall(Punto, pronosticoPartidoJugado(Jugador, Punto), Puntos),
    sum_list(Puntos, PuntosTotales).

% Punto 5

paisFavorito(Pais):-
    pais(Pais),
    puedeSerPaisFavorito(Pais).

pronosticoGanador(gana(PaisGanador, _, _, _), Pais):-
    PaisGanador = Pais.

puedeSerPaisFavorito(Pais):-
    forall(pronostico(_, Pronostico), pronosticoGanador(Pronostico, Pais)).

puedeSerPaisFavorito(Pais):-
    forall(simetriaPaises(Pais, _, GolesOtroPais, GolesPais),
           (Diferencia is GolesPais - GolesOtroPais, Diferencia >= 3)).
