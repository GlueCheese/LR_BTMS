function AM(m_in,m_out,f0,m)
%This function extracts signal from m_in, implements
%AM-modulation and stores the result in m_out. Some parameters of
%modulation are also necessar: carrying frequency f0 and modulation depth m

InputSignal=m_in.signal;
fd=m_in.fd;
T=m_in.T;


% transform input signal as if it had higher discretization frequency
nfd=5*f0; % new discretization frequency
nT=0:1/nfd:T(end);% new time range
mod_signal=interp1(T,InputSignal,nT); % input signal on higher discretization frequency


%magnitude modulation
smax=max(abs(mod_signal));
mod_signal=mod_signal/smax;
mod_signal=(1+m*mod_signal).*sin(2*pi*f0*nT);

m_out.signal=mod_signal;
m_out.fd=nfd;
m_out.T=nT;

end


