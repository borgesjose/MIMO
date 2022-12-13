%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                       %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jose Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                   %
% @email jose.borges90@hotmail.com                    %
% simulation MIMO                                     %
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
   
%% Aplicando o DEGRAU
nptos = 300;
% REF 1
for i=1:nptos,
    if (i<=nptos/2)  ref1(i)=0.5; end;
    if (i>nptos/2)   ref1(i) = 1; end;
end ;
% REF 2
for i=1:nptos,
    if (i<=nptos/2)  ref2(i)=0.5; end;
    if (i>nptos/2)   ref2(i) = 1; end;
end ;

for i=1:nptos,
    y1(i)= 0; 
    y2(i) = 0;
    y11(i)=0;
    y12(i) = 0;
    y21(i) = 0;
    y22(i)=0;
    u1(i)= 0; 
    u2(i) = 0;
    erro1(1)= 0; 
    erro2(1)= 0; 
end
 
y1(3)=0 ; y1(2)=0 ; y1(1)=0;
y2(4)=0 ; y2(3)=0 ; y2(2)=0 ; y2(1)=0;


u1(1)=0 ; u1(2)=0 ; u1(3)=0; u1(4)=0;
u2(1)=0 ; u2(2)=0 ; u2(3)=0; u2(4)=0;

erro1(1)=1 ; erro1(2)=1 ; erro1(3)=1; erro1(4)=1;
erro2(1)=1 ; erro2(2)=1 ; erro2(3)=1; erro2(4)=1;

rlevel = 0.1;
ruido = rlevel*rand(1,nptos);


for i=20:nptos,
    % 
     y11(i)= 0.9705*y11(i-1)+0.3776*u1(i-3);
     y12(i)= 0.9765*y12(i-1)-0.4474*u2(i-7);
     y21(i)= 0.9552*y21(i-1)+0.2959*u2(i-15);
     y22(i)= 0.9659*y22(i-1)-0.6621*u2(i-7);
     
     y1 = y11+y12
     y2 = y21+y22
       
      tempo(i)=i*Tamostra;
            
 end ;
%% 
figure;
t = tiledlayout(2,2);
nexttile
plot(tempo,y11)
nexttile
plot(tempo,y12)
nexttile
plot(tempo,y21)
nexttile
plot(tempo,y22)

%%
%plotar seinal de saida e  de controle:    
figure;
grid;
plot(tempo,y1,'g-');
figure;
grid;
plot(tempo,y2,'g-');


%plot(tempo,ref);
%title(['AT-PID-FG:',num2str(rlevel), ' ISE:', num2str(ISE_t2), ', ITSE:' ,num2str(ITSE_t2),', IAE:' ,num2str(IAE_t2), ', ITAE:' ,num2str(ITAE_t2)])


