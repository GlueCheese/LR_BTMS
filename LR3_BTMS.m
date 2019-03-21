% This script includes most of operations, corresponding to general steps
% of LR 3. This steps in their order-of-follow are: 
%     *impulse noise implementation and its introduction into AM signal;
%     *AM-demodulation;
%     *Comparison of signal before AM modulation and its reconstraction;
%     *50 Hz harmonic noise implementation and its introduction into
%     AM-domodulated signal;
%     *FM-demodulation;
%     *Comparison of signal before FM modulation and its reconstraction;
%Most of theese steps are followed by coresponding intermediate result
%representation in time and frequency domains.


%initialization of input and output data variables

f_am_mod_noisy='AM_Noisy.mat';
m_am_mod_noisy=matfile(f_am_mod,'Writable',true); % this file is supposed to contain all 
%necessar features of AM signal with additional noise 

f_am_demod='AM_DEMout.mat';
m_am_demod=matfile(f_am_demod,'Writable',true);% this file is supposed to contain all 
%necessar features of AM-demodulated signal

f_fm_mod_noisy='FM_Noisy.mat';
m_fm_mod_noisy=matfile(f_am_demod,'Writable',true);% this file is supposed to contain all 
%necessar features of AM-demodulated signal with additional noise

f_fm_demod='FM_DEMout.mat';
m_fm_demod=matfile(f_fm_demod,'Writable',true);

% impulse noise introduction
addPulse(m_am_mod,m_am_mod_noisy); 
F_am_noisy=figure;
subplot(2,1,1);
plot(m_am_mod_noisy.T,m_am_mod_noisy.signal);xlabel('time, s');title('modulated signal with the pulse noise in the time domain');
subplot(2,1,2);
[f,s]=getFurier(m_am_mod_noisy.T,m_am_mod_noisy.signal);
plot(f,abs(s));xlabel('frequency, Hz');title('modulated signal with the pulse noise in the frequency domain');

% AM-demodulation
AMdem(m_am_mod_noisy,m_am_demod,m_fm_mod.fd*10,0.5);
F_amdm=figure;
subplot(2,1,1);
plot(m_am_demod.T,m_am_demod.signal);title('magnitude-demodulated signal in the time domain');xlabel('time, s');
subplot(2,1,2);
[f,s]=getFurier(m_am_demod.T,m_am_demod.signal);
array=(f<m_fm_mod.fd/2)&(f>-m_fm_mod.fd/2);
plot(f(array),abs(s(array)));title('magnitude-demodulated signal in the frequency domain');xlabel('frequency, Hz');

%Comparison of signal before AM modulation and its reconstraction;
[Delay,MRS]=mrs(m_fm_mod,m_am_demod)

% harmonic (50 Hz sine) noise introduction
add50Hz(m_am_demod,m_fm_mod_noisy);
F_fm_noisy=figure;
subplot(2,1,1);
plot(m_fm_mod_noisy.T,m_fm_mod_noisy.signal);xlabel('time, s');title('modulated signal with the 50Hz sine noise in the time domain');
subplot(2,1,2);
[f,s]=getFurier(m_fm_mod_noisy.T,m_fm_mod_noisy.signal);
plot(f(array),abs(s(array)));xlabel('frequency, Hz');title('modulated signal with the 50Hz sine noise in the frequency domain');

% FM-demodulation
FMdem(m_fm_mod_noisy,m_fm_demod,m_mio.fd*10,5);
F_fmdm=figure;
subplot(2,1,1);
plot(m_fm_demod.T,m_fm_demod.signal);title('frequency-demodulated signal in the time domain');xlabel('time, s');
subplot(2,1,2);
[f,s]=getFurier(m_fm_demod.T,m_fm_demod.signal);
array=(f<m_mio.fd/2)&(f>-m_mio.fd/2);
plot(f(array),abs(s(array)));title('frequency-demodulated signal in the frequency domain');xlabel('frequency, Hz');

%Comparison of signal before AM modulation and its reconstraction;
[Delay,MRS]=mrs(m_mio,m_fm_demod)

function [Delay,MRS]=mrs(m1,m2)
% This function returns time delay and mean root square error of signal
% reconstruction

% input and output threads initialization block
T1=m1.T;
T2=m2.T;
s1=m1.signal;
s1=s1/max(abs(s1));
s2=m2.signal;
s2=s2/max(abs(s2));

% temporal allignment of signals
dt=min([T2(2)-T2(1),T1(2)-T1(1)]);
Tstart=max([T1(1),T2(1)]);
Tend=min([T1(end),T2(end)]);
T=Tstart:dt:Tend;
s1=interp1(T1,s1,T);
s2=interp1(T2,s2,T);

% cross-correlation estimation
y=xcorr(s1,s2);
[C,I]=max(y);
I=int32(I)-length(T);
% time delay estimation
Delay=-double(sign(I))*T(abs(I));

% mean root square estimation
if I<0
    s1=s1(1:end+I);
    s2=s2(1-I:end);
else
    s1=s1(1+I:end);
    s2=s2(1:end-I);
end
MRS=(s1-s2);
MRS=MRS.^2;
MRS=MRS/length(MRS);
MRS=sum(MRS);
MRS=sqrt(MRS);
end
function add50Hz(m_in,m_out)
% This function produces a 50 Hz sine noise, introduces it to the m_in signal and
% saves all necessar features to the m_out

s=m_in.signal;
T=m_in.T;
s=s+3*sin(2*pi*50*T);
m_out.signal=s;
m_out.fd=m_in.fd;
end
function addPulse(m_in,m_out)
%This function produces a repeative impulse noise, introduces it to the m_in signal and
% saves all necessar features t othe m_out
s=m_in.signal;
T=m_in.T;
fd=m_in.fd;
ti=12/fd;
[f,Fs]=getFurier(T,s);
%A=5*max(abs(Fs))/10/ti;
A=5*max(s);

Istep=floor(length(T)/11);
noise=A*rectpuls(T-T(Istep),ti);
for Idelay=2*Istep:Istep:10*Istep
    noise=noise+A*rectpuls(T-T(Idelay),ti);
end
s=s+noise;
m_out.signal=s;
m_out.T=m_in.T;
m_out.fd=m_in.fd;
end