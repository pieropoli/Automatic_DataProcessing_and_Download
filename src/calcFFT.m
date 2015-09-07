%% computation and direct plotting of fft 
% input parameters:
%
%   signal= input signal to trasform
%   Fs= sample frequency
%   type= 1) plot amplitude
%         2) plot phase
%         3) plot aplitude and phase (using subplot)
%         4) power spectral density
%


function [z,F]=calcFFT(signal,Fs,type)




z=fft(signal);

F=(0:(numel(signal))-1)*Fs/numel(signal);

if nargin<3
 type=1;   
end

if type==1
loglog(F,abs(z));
xlim([0 Fs/2])
xlabel('Frequency (hz)')
ylabel('Amplitude')
end

if type==2
  plot(F,imag(z));
xlim([0 Fs/2])
xlabel('Frequency (hz)')
ylabel('Phase')
end

if type==3
  subplot(121)
    plot(F,imag(z));
xlim([0 Fs/2])
xlabel('Frequency (hz)')
ylabel('Phase')
  subplot(122)
plot(F,abs(z));
xlim([0 Fs/2])
xlabel('Frequency (hz)')
ylabel('Amplitude')

end   

if type==4
plot(F,abs(z).^2);
xlim([0 Fs/2])
xlabel('Frequency (hz)')
ylabel('Energy')
title('Power spectral density')
end

if type==5
    disp('no plot')
    
end   





