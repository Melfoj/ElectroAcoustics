clear all;
close all; 
clc;
fs=48000;
c=340;
r0=1.206;
bbbb=404;
hz=2-mod(bbbb,10)/10;
hm=1.5-1.4*mod(bbbb,8)/7;
h=hm+hz;
dh=abs(hm-hz);
xm=3+mod(bbbb,5)/4;
L=sqrt(xm*xm+h*h);
Teta=asin(h/L);
Uz=1+mod(bbbb,4);
Um=4-mod(bbbb,4);
D=sqrt(xm*xm+dh*dh);
omega=asin(xm/D);
switch Uz
    case 1
        koefZr=1;
        koefZd=1;
    case 2
        koefZr=cos(2*pi-Teta);
        koefZd=cos(1.5*pi+omega);
    case 3
        koefZr=(1+cos(2*pi-Teta))/2;
        koefZd=(1+cos(1.5*pi+omega))/2;
    case 4
        koefZr=(1+3*cos(2*pi-Teta))/4;
        koefZd=(1+3*cos(1.5*pi+omega))/4;
end
switch Um
    case 1
        koefPr=1;
        koefPd=1;
    case 2
        koefPr=cos(pi+Teta);
        koefPd=cos(pi/2 + omega);
    case 3
        koefPr=(1+cos(pi+Teta))/2;
        koefPd=(1+cos(pi/2 + omega))/2;
    case 4
        koefPr=(1+3*cos(pi+Teta))/4;
        koefPd=(1+3*cos(pi/2 + omega))/4;
end

M=1+mod(bbbb,3);


switch M
    case 1
        m=[0.01 0.01 0.01 0.02 0.02 0.02 0.05 0.05 0.05];
    case 2
        m=[0.18 0.18 0.12 0.1 0.09 0.08 0.07 0.07 0.07];
    case 3
        m=[0.46 0.46 0.93 1.0 1.0 1.0 1.0 1.0 1.0];
end
f=[0 125 250 500 1000 2000 4000 8000 24000]/fs *2;
m=sqrt(1-m);
filt=fir2(20,f,m);


figure, plot(0,hz,"o")
hold on
plot(xm, hm, "*")
plot([-0.5 xm+0.5],[0 0],"LineWidth",6)
plot([0 xm],[hz hm])
plot([0 (xm*hz/(hz+hm)) xm], [hz 0 hm],"-.")
hold off

x=zeros(1,round(8*fs/c));%8=2*max(xm)
x(1,round(L*fs/c))=x(1,round(L*fs/c))+sqrt(r0*c/(4*pi))*abs(koefPr*koefZr/L);
x=filter(filt,1,x);
x(1,round(D*fs/c))=x(1,round(D*fs/c))+sqrt(r0*c/(4*pi))*abs(koefPd*koefZd/D);
X(1,:)=fft(x(1,:));
os=1:round(fs/(length(X)-1)):fs;
figure, plot(os,20*log10(abs(X(1:length(os)))/max(abs(X)))), ylim tight, xlim tight
figure, plot(x)
fl=125;
flo = 88.388;
freq=[];
sk=[];
while flo<=12000
    freq(end+1)=flo;
    flo=flo*2;
    sk(end+1)=fl;
    fl=fl*2;
end


for i = 1:length(freq)-1
    Y(i, 1) = sum(abs(X(1, round(8*freq(i)/c):round(8*freq(i+1)/c))).^2);
end

figure, plot(sk(1:end-1),20*log10(Y/max(abs(Y)))), title("Freq odz po oct"), xlim tight, ylim tight, ylabel("db"), xlabel("Oct");



