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
figure
step(G)
hold on 
step(Gz)
hold off
%%


Gz11
[num den] = tfdata(Gz11, 'v');
Gz11 = tf(num,den,Tc,'Variable','z^-1')

Gz12
[num den] = tfdata(Gz12, 'v');
Gz12 = tf(num,den,Tc,'Variable','z^-1')

Gz21
[num den] = tfdata(Gz21, 'v');
Gz21 = tf(num,den,Tc,'Variable','z^-1')

Gz22
[num den] = tfdata(Gz22, 'v');
Gz22 = tf(num,den,Tc,'Variable','z^-1')

%%
figure
step(G)
hold on 
step(Gz)
      
%% Aplicando o controlador - OLD version
% REF 1
for i=1:nptos,
    if (i<=nptos/2)  ref(i)=1; end;
    if (i>nptos/2)   ref(i) = 2; end;
end ;
% REF 2
for i=1:nptos,
    if (i<=nptos/2)  ref(i)=1; end;
    if (i>nptos/2)   ref(i) = 2; end;
end ;

y(4)=0 ; y(3)=0 ; y(2)=0 ; y(1)=0 ; 
u(1)=0 ; u(2)=0 ; u(3)=0; u(4)=0;

erro(1)=1 ; erro(2)=1 ; erro(3)=1; erro(4)=1;

rlevel = 0.1;
ruido = rlevel*rand(1,nptos);

for i=5:nptos,

P1(i) = p1+rlevel*rand; % Aplicando ruido na modelagem
P2(i) = p2+ruido(i);  % Aplicando ruido na modelagem
k = 2*P1(i)*P2(i); 
    
[c0,c1,c2,r0,r1,r2] = discretiza_zoh(P1(i),P2(i),k,Tc); %chama a função que discretiza o processo utilizano um ZOH;

     if (i==550),r1 = - 1.84;r2 = 0.9109;  end % Ruptura no modelo
     
     y(i)= -r1*y(i-1)-r2*y(i-2)+c0*u(i-2)+c1*u(i-3)+c2*u(i-4); % equação da diferença do processo
     
     erro(i)=ref(i)-y(i); %Erro
      
      %Controlador:

%             alpha = (Kc)*(1+((Td)/Tamostra)+(Tamostra/(2*(Ti))));
%             beta = -(Kc)*(1+2*((Td)/Tamostra)-(Tamostra/(2*(Ti))));
%             gama = (Kc)*(Td)/Tamostra;
            
      % new version
            alpha = Kc+ Kd/Tamostra + (Ki*Tamostra)/2;
            beta = -(Kc) - 2*((Kd)/Tamostra)+(Ki*Tamostra)/2;
            gama = (Kd)/Tamostra;


            u(i)= u(i-1) + alpha*erro(i) + beta*erro(i-1) + gama*erro(i-2);
      
       tempo(i)=i*Tamostra;
      fprintf('amostra:  %d \t entrada:  %6.3f \t saida:  %4.0f\n',i,u(i),y(i));
      
 end ;
 
 
     ISE_t2 = objfunc(erro,tempo,'ISE')
     ITSE_t2 = objfunc(erro,tempo,'ITSE')
     ITAE_t2 = objfunc(erro,tempo,'ITAE')
     IAE_t2 = objfunc(erro,tempo,'IAE')
     
%plotar seinal de saida e  de controle:    
figure;
grid;
plot(tempo,y,'g-');
hold on;
plot(tempo,u);
plot(tempo,ref);
title(['AT-PID-FG:',num2str(rlevel), ' ISE:', num2str(ISE_t2), ', ITSE:' ,num2str(ITSE_t2),', IAE:' ,num2str(IAE_t2), ', ITAE:' ,num2str(ITAE_t2)])
%%
%plotar P1 e P2
figure;
grid;
plot(tempo,P1,'g-');
hold on;
plot(tempo,P2);


