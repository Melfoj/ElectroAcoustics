clear all; close all; clc;

f=1000; % Frekvencija  
c=340; % Brzina zvuka u vazduhu
d=0.34; % Rastojanje izmedju izvora

teta=[0:1:359]; % Uglovi, sa ugaonom rezolucijom 1 stpen
% p=2*cos(pi*d*f/c*sin(teta*pi/180)); % Neka funkcija (jednacina 5.6 iz knjige)
p=(1+cos(teta/180*pi))/2;
% Prikaz funkcije u polarnom koordinatnom sistemu, sa ogranicavanjem osa u zeljenom opsegu
figure, mmpolar(teta/180*pi,20*log10(p/max(abs(p))),'TTickDelta',30','RLimit',[0 -15],'TLimit',[-pi pi]),hold on


