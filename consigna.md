Estamos armando un programa de prolog para hacer más fácil el manejo de un prode en la fase de eliminación directa del mundial.
Un Prode (pronósticos deportivos) es un juego en el que se intenta adivinar los resultados de partidos. Los jugadores del prode dan sus pronósticos de cómo sale cada
partido y si el pronóstico fue acertado suma puntos. Al final del prode aquel jugador que haya sumado más puntos gana.
Contamos con los siguientes hechos que representan los resultados reales de los
partidos:
%resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais).
resultado(paises_bajos, 3, estados_unidos, 1). r. Paises bajos 3 - 1
Estados unidos
resultado(australia, 1, argentina, 2). r. Australia 1 - 2 Argentina
resultado(polonia, 3, francia, 1).
resultado(inglaterra, 3, senegal, 0).
Y con hechos de esta forma que dicen qué pronosticó cada jugador del prode:
pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).
pronostico(gus, gano(estados_unidos, paises_bajos, 1 , 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1 , 0)).
Queremos implementar los siguientes predicados:
1. a- jugaron/3
Relaciona dos países que hayan jugado un partido y la diferencia de goles entre ambos.
Por ejemplo:
jugaron(francia, po/onia, Diferencia).
Diferencia = 2.
jugaron(australia, argentina, Diferencia).
Diferencia = -1.
b- ganol2
Un país le ganó a otro si ambos jugaron y el ganador metió más goles que el
otro.
2. puntosPronostico/2
Cada pronóstico al que se apuesta en el prode vale una cierta cantidad de puntos dependiendo de qué tan acertado fue respecto del resultado del partido.
Un pronóstico es un functor de cualquiera de estas formas:
gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor).
empataron(UnPais, OtroPais, GolesDeCualquieraDelosDos).
Si hay un resultado para el partido y:
el pronóstico le pegó a el ganador o a si fue empate y cantidad de goles
de ambos, vale 200 puntos.
el pronóstico le pegó al ganador o a si fue empate pero no a la cantidad de goles, vale 100 puntos.
no le pegó al ganador o a si fue empate, vale O puntos.
3. invicto/1
Un jugador del prode está invicto si sacó al menos 100 puntos en cada
pronóstico que hizo.
Ojo!: los pronósticos de partidos que aún no se jugaron no deberían tenerse en
cuenta. Por ejemplo: lucas hizo 3 pronósticos:
Países Bajos le gana a Estados Unidos 3 a 1
Argentina le gana a Australia 2 a O
Croacia le gana a Japón 1 a O
Los primeros 2 valen 200 y 100 puntos respectivamente, y el tercero aún no
tiene puntos porque no se jugó. Sin embargo, Lucas está invicto porque todos
los pronósticos que hizo que tienen puntos vienen cumpliéndose.
gus pronosticó que japón le gana a croacia 2 a O, pero el resultado ese partido
aún no está en la base de conocimientos
4. puntaje/2
Relaciona un jugador con el total de puntos que hizo por todos sus pronósticos.
5. favorito/1
un país es favorito si todos los pronósticos que se hicieron sobre ese país lo ponen como ganador o si todos los partidos que jugo los gano por goleada (por diferencia de al menos 3 goles).