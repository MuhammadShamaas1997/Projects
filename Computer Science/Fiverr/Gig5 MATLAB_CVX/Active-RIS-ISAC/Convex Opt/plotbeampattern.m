clear all;close all;
load Sensing_001_beampattern
SINR2=zeros(1,101);
i=0;
for azimuth=-0.5*pi:0.01*pi:0.5*pi
    i=i+1;
    n=0:N-1;
    aAoDirstg=exp(imaginary*n*pi*sin(2*pi*azimuth));
    aAoAirstg=exp(imaginary*n*pi*sin(2*pi*azimuth));
    As=sqrt(calbeta(DisIRS2TG))*aAoDirstg'*aAoAirstg;
    B=G'*Phi'*As*Phi*G;
    SINR2(i)=trace(B*R*B'/J_t1);%J???R??????RIS??????????????? 
    beam(i)=trace(R*B');
end
%SINR2=SINR2/iniConvout(OutNmax)
beam=10*log10(beam/max(beam));
plot(1:101,beam,'.-','LineWidth',1.25)
hold on;

%%
load 001_beam_36
SINR2=zeros(1,101);
i=0;
for azimuth=-0.5*pi:0.01*pi:0.5*pi
    i=i+1;
    n=0:N-1;
    aAoDirstg=exp(imaginary*n*pi*sin(2*pi*azimuth));
    aAoAirstg=exp(imaginary*n*pi*sin(2*pi*azimuth));
    As=sqrt(calbeta(DisIRS2TG))*aAoDirstg'*aAoAirstg;
    B=G'*Phi'*As*Phi*G;
    SINR2(i)=trace(B*R*B'/J_t1);%J???R??????RIS??????????????? 
    beam(i)=trace(R*B');
end
%SINR2=SINR2/iniConvout(OutNmax)
beam=10*log10(beam/max(beam));
plot(1:101,beam,'.-','LineWidth',1.25)
hold on;