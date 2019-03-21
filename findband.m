function [flow,fc,fhigh]=findband(f,s,part)
%This function estimates input signal frequensy range of the most significance.
%This range contains most of signal energy.
% "s" is supposed to be signal spectrum, "f" - corresponding frequency

% signal power calculation
s=abs(s).^2;


fc=sum(s.*f)/sum(s); % average frequency of signal

[m,i0]=min(abs(f-fc));
p0=sum(s)*part;
p=s(i0);
ilow=i0;
ihigh=i0;
while p<p0
    if ilow>1
       ilow=ilow-1;
        p=p+s(ilow);
    end
    if ihigh<length(s)
        ihigh=ihigh+1;
        p=p+s(ihigh);
    end
end
flow=f(ilow);
fhigh=f(ihigh);