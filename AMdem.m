function AMdem(m_in,m_out,f0,m)
%This function extracts signal from m_in, implements
%AM-demodulation and stores the result in m_out. Some parameters of
%modulation are also necessar: carrying frequency f0 and modulation depth m

InputSignal=m_in.signal;
T=m_in.T;
fd=m_in.fd;

%Low pass filter designing
LP=designfilt('lowpassiir','PassbandFrequency',f0/2,'StopbandFrequency',f0-50,'PassbandRipple',0.1,'StopbandAttenuation',80,'SampleRate',fd);

%demodulation block
dem_sig=InputSignal.*sin(2*pi*f0*T);
dem_sig=filter(LP,dem_sig);
dem_sig=(dem_sig*2-1)/m;

%This steps simulates input range limitations of an analog prototype
dem_sig(dem_sig>1)=1;
dem_sig(dem_sig<-1)=-1;


m_out.signal=dem_sig;
m_out.T=T;
m_out.fd=fd;


