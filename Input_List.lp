%%%% Entrada de Instrumentos %%%%

%Se catalogan los instrumentos por 5 es de rangos frequenciales
%Bass, mid_bass, Mid, Mid_High, High 

%% Que instrumentos van a aparecer%%

%Voz
instOn(voz, all).

%Guitarras
%instOn(guitarra_ac, mid).

%Piano
instOn(piano_L, all).
instOn(piano_R, all).

%instOn(guitarra_el, mid).

%Bajo
%instOn(bass, bass).

%Bateria%
instOn(kick_In, bass).
%instOn(kick_Out, bass).
% instOn(hihat).
% instOn(tom1).
% instOn(tom2).
% instOn(overhead_R).
% instOn(overhead_L).


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

#const nv=3.

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

%% Restricción de Pares por Instrumento

%El Piano L y Piano R deben de tener los mismos pre-amps y mics
error :- inst_mic(piano_L,V1), inst_mic(piano_R,V2), V1 != V2.
error :- pre_inst_mic(piano_L,_,PPL), pre_inst_mic(piano_R,_,PPR), PPL != PPR.

%El OH L y OH R deben de tener los mismos pre-amps y mics
error :- inst_mic(overhead_L,V3), inst_mic(overhead_R,V4), V3 != V4.
error :- pre_inst_mic(overhead_L,_,POL), pre_inst_mic(overhead_R,_,POR), POL != POR.

%El Room L y Room R deben de tener los mismos pre-amps y mics
error :- inst_mic(room_L,V5), inst_mic(room_R,V6), V5 != V6.
error :- pre_inst_mic(room_L,_,PRL), pre_inst_mic(room_R,_,PRR), PRL != PRR.



%%1. Es un error no usar un microfono especial para un registro
error :- pre_inst_mic(I,_,P), instOn(I,R1), mic(M,R2), R1 != R2.



%FALTANTE %%2. Es un error que más de 2 inst_mic tengan asignado el ua_2610
%error :- pre_inst_mic(I,_,P), pre(P, R3),  P == ua_2610, R3 < (pre(P)).
%error :- pre_inst_mic(I,_,P), pre(P, R3),  P == ua_2610, R3 > 2.



% 3. Solo el bajo y guitarra puede ir por linea.
error :- pre_inst_mic(I,M,_), M == dbx, I != bass.

% 4. solo guitarra_electrica puede ir por linea (Pendiente en abrir la condición del instrumento)
%error :- pre_inst_mic(I,M,_), M == dbx, I != guitarra_el.


%%3, Es un error usar un C12 en el Kick In
error :- pre_inst_mic(I,M,_), M == telefunken_c12, I == kick_In.

%4. Que alguien que no sea N3, elije un microfono N3
error :- pre_inst_mic(I,M,_), mic(M,_,Level), Level == n3, nv != 3.

%4. Si eres N1 solo puedes usar micrófonos catalogados como N1
error :- pre_inst_mic(I,M,_), mic(M,_,Level), Level == n2, nv == 1.



%%No se pueden usar micrófonos 
%D112
error :- pre_inst_mic(I,M,_), M == akg_d112, I == voz.
%error :- pre_inst_mic(I,M,_), instOn(I, R1), mic(M,R2), R1 == R2.





%%Para Live session

%1. El C12 solo puede ir a la voz
error :- pre_inst_mic(I,M,_), M == telefunken_c12, I != voz, e == 2.

%2. El bajo SIEMPRE se graba por linea
error :- pre_inst_mic(I,M,_), M != dbx, I == bass, e == 2.


:- error.
#show pre_inst_mic/3.



