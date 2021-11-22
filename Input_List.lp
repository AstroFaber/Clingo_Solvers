%%%% Entrada de Instrumentos %%%%

%Se catalogan los instrumentos por 5 es de rangos frequenciales
%Bass, mid_bass, Mid, Mid_High, High 

%% Que instrumentos van a aparecer%%

%Voz
instOn(voz, all).

%Guitarras
%instOn(guitarra_ac, mid).

%Piano
%instOn(pianoL, all)
%instOn(pianoR, all)

instOn(guitarra_el, mid).

%Bajo
instOn(bass, bass).

%Bateria%
instOn(kick_In, bass).
%instOn(kick_Out, bass).
% instOn(hihat).
% instOn(tom1).
% instOn(tom2).
% instOn(overhead_r).
% instOn(overhead_l).


%Microfonos
%Modelo de Micrófono, 
%Mejor rango: bass, all, vocal,
mic(akg_c214, all, n1).
mic(akg_c414, all, n1).
mic(akg_d112, bass, n1).
mic(telefunken_c12, all, n3).
mic(dbx, bass, n2).


%%
%Pre-amp
pre(neve,4).
pre(ua_2610,2).

%% SELECCIONTAR ---------------

%Nivel de acreditación?
%n1, n2, n3

#const nv=2.


%Multitrack o Live Session?
%Multitrack = 1, LiveSession = 2. 

#const e=1.

%%PRINCIPAL ------------------------------------------------
%I = Instrumento
%M = Microfono
%P = Pre

%se elige un microfono a cada instrumento
1 { inst_mic(I,M) : mic(M,_,_) } 1 :- instOn(I,_).

%Se elige el pre-amplificador a cada instrumento con mic
1 { pre_inst_mic(I,M,P) : pre(P,_)} 1:- inst_mic(I,M).



%% Restricciones

%%1. Es un error usar un microfono especial para un registro
error :- pre_inst_mic(I,M,_), instOn(I,R1), mic(M,R2), R1 != R2.


%FALTANTE %%2. Es un error que más de 2 inst_mic tengan asignado el ua_2610
%error :- pre_inst_mic(I,_,P), pre(P, R3),  P == ua_2610, R3 < (pre(P)).

% 3. Solo el bajo y guitarra puede ir por linea.
error :- pre_inst_mic(I,M,_), M == dbx, I != (bass).

% 4. solo guitarra_electrica puede ir por linea (Pendiente en abrir la condición del instrumento)
%error :- pre_inst_mic(I,M,_), M == dbx, I != guitarra_el.


%%3, Es un error usar un C12 en el Kick In
error :- pre_inst_mic(I,M,_), M == telefunken_c12, I == kick_In.

%4. Que alguien que no sea N3, elije un microfono N3
error :- pre_inst_mic(I,M,_), mic(M,_,Level), Level == n3, nv != 3.

%4. Que alguien que no sea N2, elije un microfono N2
%error :- pre_inst_mic(I,M,_), mic(M,_,Level), Level == n2, nv != n2.



%%Para Live session

%1. El C12 solo puede ir a la voz
error :- pre_inst_mic(I,M,_), M == telefunken_c12, I != voz, e == 2.

%2. El bajo SIEMPRE se graba por linea
error :- pre_inst_mic(I,M,_), M != dbx, I == bass, e == 2.


:- error.
#show pre_inst_mic/3.



