clear all, close all, clc
%ucitavanje i sredjivanje signala
[x, fs] = audioread('signal 4.wav');
DC=mean(x);
x=x-DC;%jednosmerna komponenta
n=max(abs(x));
x=x./n;%usrednjavanje
T=1/fs;
RMS = 20*log10(rms(x));%rms
C=20*log10(n/RMS);%krest
op= T:T:length(x)*T;
figure, plot(op, x)
xlim([0 13])
ylim([-1.1 1.1])
title("Vremenski oblik X")

% Kreiranje filtara
BandsPerOctave=1;
N=6;           % Red filtra
F0=1000;       % Fiksni parametar
f=fdesign.octave(BandsPerOctave,'Class 1','N,F0',N,F0,fs);

F0=validfrequencies(f);
Nfc=length(F0);
for i=1:Nfc,
    f.F0=F0(i);
    Hd(i)=design(f,'butter');
end
for i=1:Nfc
    y=filter(Hd(i),x);
    if i==5
        figure, plot(op, y/max(abs(y)))
        xlim([0 13])
        ylim([-1.1 1.1])
        title("Vremenski oblik Y")
    end
    RMSY(i)=20*log10(rms(y));
end

freq0 = [];
flo = 22.097;
while flo<=22.097*(2^Nfc)
    if flo ~= 22.097
        freq0(end+1) = flo*0.9999;
    end
    if flo <=22.097*(2^(Nfc-1))
    freq0(end+1) = flo;
    end
    flo = flo*2;
end

RMSyOsa = [];
for i = 1:length(RMSY)
    RMSyOsa(end+1) = RMSY(i);
    RMSyOsa(end+1) = RMSY(i);
end

figure, semilogx(freq0,RMSyOsa)
title("Oktavni spektar")

for i=2:Nfc+2-1
    w=sprintf("C%s",num2str(i));
    xlswrite("Rezultati.xlsx",RMSY(i-1),1,w);
end
