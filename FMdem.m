function FMdem(m_in,m_out,f0,df)
%This function extracts signal from m_in, implements
%FM-demodulation and stores the result in m_out. Some parameters of
%modulation are also necessar: carrying frequency f0 and frequency
%deviation df

%signal features extraction
InputSignal=m_in.signal;
fd=m_in.fd;
T=m_in.T;

% Synthes of the low pass filter
LP=designfilt('lowpassiir','PassbandFrequency',f0/2,'StopbandFrequency',f0-50,'PassbandRipple',0.1,'StopbandAttenuation',80,'SampleRate',fd);

% demodulation block
s1=InputSignal.*sin(2*pi*f0*T);
s1=filter(LP,s1);

s2=InputSignal.*cos(2*pi*f0*T);
s2=filter(LP,s2);

dem_sig=-atan(s1./s2);
dem_sig=unwrap(2*dem_sig)/2;

dT=T(2)-T(1);
dem_sig=[0,diff(dem_sig)/dT]/(2*pi*df);

%This steps simulates input range limitations of an analog prototype
dem_sig(dem_sig>1)=1;
dem_sig(dem_sig<-1)=-1;

m_out.signal=dem_sig;
m_out.T=T;
m_out.fd=fd;


