function FM(m_in,m_out,f0,df)
%This function extracts signal features from m_in, implements
%FM-modulation and stores the result in m_out. Some parameters of
%modulation are also necessar: carrying frequency f0 and frequency
%deviation df

ImputSignal=m_in.signal;
fd=m_in.fd;
T=m_in.T;

% transform imput signal as if it had higher discretization frequency
nfd=f0*5; % new discretization frequency
nT=0:1/nfd:T(end);% new time range
nSignal=interp1(T,ImputSignal,nT); % imput signal on higher discretization frequency



%frequency modulation
smax=max(abs(nSignal));
norm_sig=nSignal/smax; 
dt=nT(2)-nT(1);
ph=cumsum(norm_sig);
ph=dt*df*ph+f0*nT;
ph=ph*2*pi;
mod_signal=sin(ph);

m_out.signal=mod_signal;
m_out.fd=nfd;
m_out.T=nT;

