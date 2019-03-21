% This script includes most of operations, corresponding to general steps
% of LR 1. This steps in theit order-of-follow are:
%     input signal representation;
%     FM-modulation;
%     representation of modulated signal in time and frequency domain;


f_mio='InputSignal.mat';
m_mio=matfile(f_mio);% this file is contains all necessar features of source signal

f_fm_mod='FMout.mat';
m_fm_mod=matfile(f_fm_mod,'Writable',true);% this file is supposed to contain all 
%necessar features of FM signal

F_mio=figure;
subplot(2,1,1);
plot(m_mio.T,m_mio.signal);title('miogram in the time domain');xlabel('time, s');
subplot(2,1,2);
[f,s]=getFurier(m_mio.T,m_mio.signal);
plot(f,abs(s));title('miogram in the frequency domain');xlabel('frequency, Hz');
[fslow,fsc,fshigh]=findband(f,s,0.95) % signal bandwidth and central frequency estimation

% FM-modulation
FM(m_mio,m_fm_mod,m_mio.fd*10,5);
F_fmm=figure;
subplot(2,1,1);
plot(m_fm_mod.T,m_fm_mod.signal);title('frequency-modulated signal in the time domain');xlabel('time, s');
subplot(2,1,2);
[f,s]=getFurier(m_fm_mod.T,m_fm_mod.signal);
plot(f,abs(s));title('frequency-modulated signal in the frequency domain');xlabel('frequency, Hz');
[fslow,fsc,fshigh]=findband(f(f>0),s(f>0),0.95) % signal bandwidth and central frequency estimation