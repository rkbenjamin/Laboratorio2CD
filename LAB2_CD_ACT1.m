clc;
clear;
close all;

bit_rate=1;
bits=randi([0 1], 1, 10000);
amplitud=1;
muestras_por_bit=40;
Fs=bit_rate*muestras_por_bit;
t_total=length(bits)/bit_rate;
t=0:Ts:t_total-Ts;

senal_NRZ=repelem(2*bits-1, muestras_por_bit); 

roll_off_factors=[0, 0.25, 0.75, 1];
colores=['b', 'r', 'g', 'm'];

for i=1:length(roll_off_factors)
    alpha=roll_off_factors(i);

    span=6;
    filtro=rcosdesign(alpha, span, muestras_por_bit, 'normal');

    senal_filtrada=conv(senal_NRZ, filtro, 'same');

    SNR=30;
    senal_ruidosa=awgn(senal_filtrada, SNR, 'measured');

    eyediagram(senal_ruidosa, 2*muestras_por_bit);
    title(['Diagrama de Ojo (α = ' num2str(alpha) ')']);
end