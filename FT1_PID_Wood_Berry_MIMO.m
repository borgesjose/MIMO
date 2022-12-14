%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Universidade Federal do Piauí                      %
% Campus Ministro Petronio Portela                    %
% Copyright 2022 -Jose Borges do Carmo Neto-          %
% @author José Borges do Carmo Neto                  %
% @email jose.borges90@hotmail.com                    %
% simulation pid MIMO                                 %
%  -- Version: 1.0  - 18/09/2022                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coluna de destilação descrita em Wood e Berry (1973)

%% Aplicando o controlador - OLD version
nptos = 1000;
Tc=0.5;
Tamostra = Tc;
eps=1;
%eps=10;
dh= 1;
dl= -1;

% REF 1
for i=1:nptos,
    if (i<=nptos/2)  ref1(i)=.5; end;
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
    u1(i)=dh; 
    u2(i) = 1;
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
%%%%%%%%%%%%%%%%% MALHA 1
%round 1
% Kc1 = 0.0607;
% Ki1 = 0.053103;
% Kd1 = 0.39175;
%round 2
% Kc1 = 0.25476;
% Ki1 = 0.025788;
% Kd1 = 0.62921;
%round 3
Kc1 = 0.123;
Ki1 = 0.012;
Kd1 = 0.33;
%%%%%%%%%%%%%%%%%%% MALHA 2
%round 1
% Kc2 = -0.076819;
% Ki2 =-0.021289;
% Kd2 =-0.069299;
% round 2
Kc2 =  -0.14366;
Ki2 =-0.029189;
Kd2 =-0.17676;
% round 3
% Kc2 =  -0.165;
% Ki2 =-0.026;
% Kd2 =-0.27676;
%%%%%%%%%%%%%%%%%%%%%%%

    
    
for i=20:nptos,
    % 
     y11(i)= 0.9705*y11(i-1)+0.3776*u1(i-3);
     y12(i)= 0.9765*y12(i-1)-0.4474*u2(i-7);
     y21(i)= 0.9552*y21(i-1)+0.2959*u2(i-15);
     y22(i)= 0.9659*y22(i-1)-0.6621*u2(i-7);
     
     y1 = y11+y12;
     y2 = y21+y22;
     
     erro1(i)=ref1(i)-y1(i); %Erro
     erro2(i)=ref2(i)-y2(i); 
     
      %Controlador:
%             % GC1
            alpha1 = Kc1+ Kd1/Tamostra + (Ki1*Tamostra)/2;
            beta1 = -(Kc1) - 2*((Kd1)/Tamostra)+(Ki1*Tamostra)/2;
            gama1 = (Kd1)/Tamostra;
%             % GC2
            alpha2 = Kc2+ Kd2/Tamostra + (Ki2*Tamostra)/2;
            beta2 = -(Kc2) - 2*((Kd2)/Tamostra)+(Ki2*Tamostra)/2;
            gama2 = (Kd2)/Tamostra;


               u1(i)= u1(i-1) + alpha1*erro1(i) + beta1*erro1(i-1) + gama1*erro1(i-2);
               
%                if ((abs(erro1(i)) >= eps) & (erro1(i)  >0))      u1(i) =  dh; end;
%                if ((abs(erro1(i)) > eps) & (erro1(i) < 0))      u1(i) = dl; end;
%                if ((abs(erro1(i)) < eps) & (u1(i-1) == dh))   u1(i) =  dh; end;
%                if ((abs(erro1(i)) < eps) & (u1(i-1) == dl))  u1(i) = dl; end;
               
               u2(i)= u2(i-1) + alpha2*erro2(i) + beta2*erro2(i-1) + gama2*erro2(i-2);
%                if ((abs(erro2(i)) >= eps) & (erro2(i)  >0))      u2(i) =  dh; end;
%                if ((abs(erro2(i)) > eps) & (erro2(i) < 0))      u2(i) = dl; end;
%                if ((abs(erro2(i)) < eps) & (u2(i-1) == dh))   u2(i) =  dh; end;
%                if ((abs(erro2(i)) < eps) & (u2(i-1) == dl))  u2(i) = dl; end;
      
      tempo(i)=i*Tamostra;
      
      
 end ;

%%
figure;
subplot(2,2,1)
plot(tempo,y11)
title('out 11')

subplot(2,2,2)
plot(tempo,y12)
title('out 12')

subplot(2,2,3)
plot(tempo,y21)
title('out 21')

subplot(2,2,4)
plot(tempo,y22)
title('out 22')

 %% 
 
%      ISE_t2 = objfunc(erro,tempo,'ISE')
%      ITSE_t2 = objfunc(erro,tempo,'ITSE')
%      ITAE_t2 = objfunc(erro,tempo,'ITAE')
%      IAE_t2 = objfunc(erro,tempo,'IAE')
     
%plotar seinal de saida e  de controle:    
figure;
grid;
plot(tempo,y1,'g-');
hold on
plot(tempo,u1,'r-');
plot(tempo,ref1,'r-');
legend('y1','u1','ref')

figure;
grid;
plot(tempo,y2,'g-');
hold on
plot(tempo,u2,'r-');
plot(tempo,ref2,'r-');
legend('y2','u2','ref')

%plot(tempo,ref);
%title(['AT-PID-FG:',num2str(rlevel), ' ISE:', num2str(ISE_t2), ', ITSE:' ,num2str(ITSE_t2),', IAE:' ,num2str(IAE_t2), ', ITAE:' ,num2str(ITAE_t2)])
%%
% Salvar dados:
trail = ['./results/','pid-3','/','malha1'];
if (~exist(trail)) mkdir(trail);end   
save([trail, '/y1.dat'],'y1', '-ascii')
save([trail, '/y2.dat'],'y2', '-ascii')
 
save ([trail, '/u1.dat'], 'u1', '-ascii')
save ([trail, '/u2.dat'], 'u2', '-ascii')

save([trail, '/tempo.dat'],'tempo', '-ascii')
save ([trail, '/ref1.dat'], 'ref1', '-ascii')
save ([trail, '/ref2.dat'], 'ref2', '-ascii')
save([trail, '/erro1.dat'],'erro1', '-ascii')
save([trail, '/erro2.dat'],'erro2', '-ascii')

save([trail, '/dh.dat'],'dh', '-ascii')
save([trail, '/dl.dat'],'dl', '-ascii')
save([trail, '/eps.dat'],'eps', '-ascii')

save([trail, '/nptos.dat'],'nptos', '-ascii')
%%
format shortg;
data_horario_test = datestr(clock,'yyyy-mm-dd THH-MM-SS');
save( [trail,'/','DATASET-',data_horario_test])


