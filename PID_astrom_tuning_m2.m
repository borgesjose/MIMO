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

kont = 0;
for t = 4:Qde_amostras,
   if u2(t) ~= u2(t-1)
      kont = kont + 1;
      ch(kont) = t;
   end
end
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

    
%% %********Sintonia de Controladores PID Método do Astron (Ziegler-Nichols Modificado)
P=0;
I=0;
D=0;
%*********  Período de amostragem  *******
% Ler do prompt - Tamostra=0.5;

%***********  Dados do Relé  ****************
% Ler do prompt

%******************Identifica a FT do processo na frequência*******
gw=-(pi*sqrt(a^2-eps^2))/(4*d) %PROCESSO: valor da ft pro relé.

%gw = -0.2134+0.4488i;
rp=abs(gw); 
fip=atan(eps/sqrt(a^2-eps^2))
%fip=angle(gw)
%%
omega = w;

%*********Especificações*************
fim= 210;
rs=.15*rp;
fis=pi*fim/180;

%*************Cálculo dos Parâmetros do Controlador***********
Kc=rs*cos(fis-fip)/rp     
aux1=sin(fis-fip)/cos(fis-fip);
aux2=sqrt(1+aux1^2);
aux3=aux1+aux2;
Td=aux3/(2*omega);
Ti=4*Td;

P=Kc
I=Kc/Ti
D=Kc*Td




%    P=0.35
 %   I=0.04523
  %  D=0.81648