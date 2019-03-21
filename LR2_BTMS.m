% This script includes most of operations, corresponding to general steps
% of LR 2. This steps in theit order-of-follow are: 
%     AM-modulation;
%     representation of modulated signal in time and frequency domain;


f_fm_mod='FMout.mat';
m_fm_mod=matfile(f_fm_mod,'Writable',true);% this file is contains all necessar features of source signal


f_am_mod='AMout.mat';
m_am_mod=matfile(f_am_mod,'Writable',true);% this file is contains all necessar features of AM signal


% modulation block
AM(m_fm_mod,m_am_mod,m_fm_mod.fd*10,0.5);
F_amm=figure;
subplot(2,1,1);
plot(m_am_mod.T,m_am_mod.signal);title('magnitude-modulated signal in the time domain');xlabel('time, s');
subplot(2,1,2);
[f,s]=getFurier(m_am_mod.T,m_am_mod.signal);
plot(f,abs(s));title('magnitude-modulated signal in the frequency domain');xlabel('frequency, Hz');
[fslow,fsc,fshigh]=findband(f(f>0),s(f>0),0.95)