load 'y1.dat'
load 'y2.dat'
load 'u1.dat'
load 'u2.dat'
load 'tempo.dat'
load 'ref1.dat'
load 'ref2.dat'
load 'erro1.dat'
load 'erro2.dat'
load 'dl.dat'
load 'dh.dat'
load 'eps.dat'
load 'nptos.dat'
%%
plot(tempo,y2)
hold on
plot(tempo,u2)
%%
Qde_amostras = nptos ;
Tamostra = .5
n = 200;

ep = eps;
maxi=max(y2(nptos/2:end));
mini= min(y2(nptos/2:end));
d=(dl-dh)
%%  
a=(maxi-mini)/2
  img=((pi*ep)/(4*d))
  real=((-pi)/(4*d))*sqrt((a^2)-(ep^2))
  g=real-j*img
%%
kont = 0;
for t = 4:Qde_amostras,
   if u2(t) ~= u2(t-1)
      kont = kont + 1;
      ch(kont) = t;
   end
end
%%
Tu1 = (ch(3) - ch(2))*Tamostra
Tu2 = (ch(4) - ch(3))*Tamostra
Tu = Tu1 + Tu2
w = (2*pi)/(Tu)

% --- Calcula valor de pico positivo
amp_max = eps;
for t =1:Qde_amostras,
   if y2(t) >= amp_max  amp_max = y2(t); end;
end;
%%
num = 0;
den = 0;
for j=(n/2):(n/2)+ceil(Tu),
    num = num + y2(j);
    den = den + u2(j);
end
Kp = num/den
  %******************Calculo ganho e fase do processo*******
gw=-(pi*sqrt(a^2-eps^2))/(4*d)
%%
    Ku = -1/gw
    %Tu = (2*pi)/w; 

    L = 10;
   
    c = 1/Kp
    b = sin(w*L)/(w*Ku)
    a = (c + cos(w*L))/(w^2)
    
%% Sintonizanodo o PID: AT-PID-FG

    Am = 5;
    Theta_m = (180/2)*(1-(1/Am));

    K = (pi/(2*Am*L))*[b;c;a];
    Kc = K(1);
    Ki = K(2);
    Kd = K(3);
    K
    

    Td = Kd/Kc;
    Ti = Kc/Ki;
%%
% Salvar dados:
format shortg;
data_horario_test = datestr(clock,'yyyy-mm-dd THH-MM-SS');

trail = ['./results/','PID_FG_malha2','/',data_horario_test];
if (~exist(trail)) mkdir(trail);end   
save([trail, '/Kc2.dat'],'Kc', '-ascii')
save([trail, '/Ki2.dat'],'Ki', '-ascii')
save ([trail, '/Kd2.dat'], 'Kd', '-ascii')    
