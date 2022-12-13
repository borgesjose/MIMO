
Qde_amostras = nptos ;
n = 200;

ep = eps;
maxi=max(y1(nptos/2:end));
mini= min(y1(nptos/2:end));
d=(dh-dl)/2 
%%  
a=(maxi-mini)/2
  img=((pi*ep)/(4*d))
  real=((-pi)/(4*d))*sqrt((a^2)-(ep^2))
  g=real-j*img

kont = 0;
for t = 4:Qde_amostras,
   if u1(t) ~= u1(t-1)
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
   if y1(t) >= amp_max  amp_max = y1(t); end;
end;
%%
num = 0;
den = 0;
for j=(n/2):(n/2)+ceil(Tu),
    num = num + y1(j);
    den = den + u1(j);
end
Kp = num/den
  %******************Calculo ganho e fase do processo*******
gw=-(pi*sqrt(a^2-eps^2))/(4*d)
%%
    Ku = -1/gw;
    %Tu = (2*pi)/w; 

    L = 12;
   
    c = 1/Kp;
    b = sin(w*L)/(w*Ku);
    a = (c + cos(w*L))/(w^2);
    
%% Sintonizanodo o PID:

    Am = 1;
    Theta_m = (180/2)*(1-(1/Am));

    K = (pi/(2*Am*L))*[b;c;a];
    Kc = K(1);
    Ki = K(2);
    Kd = K(3);
    K
    

    Td = Kd/Kc;
    Ti = Kc/Ki;
    
    