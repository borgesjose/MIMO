%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jose Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% simulation MIMO                                     %
%                                                     %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coluna de destilação descrita em Wood e Berry (1973)

%% 1 - Tratando o processo:

% Nesta etapa o processo � discretizado:
% Sendo:


    K11 = 12.8;
    K12 = -18.9;
    K21 = 6.6;
    K22 = -19.4;
    t11 = 16.7;
    t12 = 21;
    t21 = 10.9;
    t22 = 14.4;
    L11 = 1;
    L12 = 3;
    L21 = 7;
    L22 = 3;
    
    Tc=0.5;
    Tamostra = Tc;
    
%% Discretizamos o processo utilizando um segurador de ordem zero:

    s = tf('s');

    G11 = exp(-L11*s)*K11/(t11*s+1)
    G12 = exp(-L12*s)*K12/(t12*s+1)
    G21 = exp(-L21*s)*K21/(t21*s+1)
    G22 = exp(-L22*s)*K22/(t22*s+1)
    
    G = [G11,G12;G21,G22]

    Gz11 = c2d(G11,Tc,'zoh')
    Gz12 = c2d(G12,Tc,'zoh')
    Gz21 = c2d(G21,Tc,'zoh')
    Gz22 = c2d(G22,Tc,'zoh')
    
    Gz = [Gz11,Gz12;Gz21,Gz22]
%%

Gz11
[num den] = tfdata(Gz11, 'v')
Gz11 = tf(num,den,Tc,'Variable','z^-1')

Gz12
[num den] = tfdata(Gz12, 'v')
Gz12 = tf(num,den,Tc,'Variable','z^-1')

Gz21
[num den] = tfdata(Gz21, 'v')
Gz21 = tf(num,den,Tc,'Variable','z^-1')

Gz22
[num den] = tfdata(Gz22, 'v')
Gz22 = tf(num,den,Tc,'Variable','z^-1')

%%
step(G)
hold on 
step(Gz)
    
%%    



