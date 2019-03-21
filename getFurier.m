function [f,Fs]=getFurier(T,s)
%This program returns FFT of signal s, simmetric beside zero

Fs=fft(s);
Fs=(T(2)-T(1))*Fs;
Fs=circshift(Fs,floor(length(Fs)/2));
f=(0:length(T)-1)-floor(length(T)/2);
f=f/length(f);
f=f/(T(2)-T(1));