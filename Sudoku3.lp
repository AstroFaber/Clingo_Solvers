
%Números del sudoku
posicion(1,1,1).
posicion(2,3,2).
posicion(3,2,3).
posicion(4,4,4).


%Tamaño del tablero
#const t= 4.


%Tamaño del tablero (conversión al raíz cúbica)
#const st = 2.
p(st).

%Cadencia Numérica
x(1..t).
y(1..t).
n(1..t).

%---------------DEFINICIONES----------- 

%Posición del número
{posicion(X,Y,N): n(N)}=1 :- x(X) ,y(Y).

%Cuadrado
cuadrado(X,Y,A,B) :- x(X), x(A), y(Y), y(B),(X-1)/st == (A-1)/st, (Y-1)/st == (B-1)/st.

%---------------RESTRICCIONES----------- 

%No mismo número por columna
:- posicion(X,Y,N), posicion(A,Y,N), X!=A.

%No mismo número por fila
:- posicion(X,Y,N), posicion(X,B,N), Y!=B.

%No mismo número por cuadrado
:- posicion(X,Y,V), posicion(A,B,V), cuadrado(X,Y,A,B), X != A, Y != B.

%Filtrar resultados
#show posicion/3.
#show p/1.