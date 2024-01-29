clear all;
close all; 
clc;
%% const
Pa=1;
r=10;
ro=1.206;
c=340;
fs=48000;
tau=round(r*fs/c);
udeok=360;
x=zeros(udeok,2*tau);
bbbb=404;
gggg=2019;
M=3+mod(bbbb,8);
D=2-mod(bbbb,10)/10;
if M==1
    d=0;
else
    d=D/(M-1);
end
%% tacka 5
t=2*pi/90:2*pi/90:2*pi;
xizv=zeros(1,M);
yizv=(((1-M)/2):((M-1)/2))*d;
figure, plot(10*cos(t),10*sin(t),"-.", xizv, yizv, "o"), grid on, xlim([-11 11]), ylim([-11 11]), axis square
%% tacka 3 i 6
U=1+mod(bbbb,4);
p=zeros(udeok,M);
Teta=0:(2*pi/udeok):2*pi*(udeok-1)/udeok;
switch U
    case 1
        koef=ones(1,udeok);
    case 2
        koef=cos(Teta);
    case 3
        koef=(1+cos(Teta))/2;
    case 4
        koef=(1+3*cos(Teta))/4;
end
f=gggg*3-bbbb*8;
%% tacka 7.1
flo = 88.388;
freq=[];
while flo<=12000
    freq(end+1)=flo;
    flo=flo*2;
end
%% signaljenje
for i=1:udeok
    for j=1:M
        xkord=r*cos(Teta(i));
        ykord=r*sin(Teta(i))-(j-(M+1)/2)*d;
        R=sqrt(xkord^2 + ykord^2);
            x(i,round(R*fs/c))=x(i,round(R*fs/c))+sqrt(ro*c*Pa/(4*pi))*abs(koef(i)/R);
    end
    X(i,:)=fft(x(i,:));
end
%% tacka 7.2
figure, mmpolar(Teta,20*log10(X(:,round(2*f*tau/fs))./max(abs(X(:,round(2*f*tau/fs))))),'TTickDelta',30','RLimit',[0 -15],'TLimit',[-pi pi]),hold on
%% oktavni spekt
Y=zeros(length(freq)-1,height(X));
for i=1:height(X)
    for j=1:length(freq)-1
        Y(j,i)= sum(abs(X(i,round(2*freq(j)*tau/fs):round(2*freq(j+1)*tau/fs))).^2);
    end
end
for i=1:height(Y)
    figure, mmpolar(Teta,20*log10(Y(i,:)/max(abs(Y(i,:)))),'TTickDelta',30','RLimit',[0 -15],'TLimit',[-pi pi]), title("Oktavni spektar "+ num2str(125*(2^(i-1)))),hold on
end