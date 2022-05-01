%%%%%%%%%%
% compares different FT impementations 
%%%%%%%%%
%% The DTFT in loop-form
clear; close all;
% create the signal
% for i = 1:10
srate  = 1000; % hz
power = 12;
time = 0:1/srate:((2^power-1)/srate); % time vector in seconds
pnts   = length(time); % number of time points
signal = 2.5 * sin( 2*pi*4*time ) ...
       + 1.5 * sin( 2*pi*6.5*time );


hex = sfi(signal, 27, 14).hex;
hex = strsplit(hex);
fileID = fopen('test.txt','w');
for i = 1:pnts
    string = cell2mat(hex(i));
    fprintf(fileID, '%s\n', string);
end
fclose(fileID);
% fprintf(fileID,'%6s %12s\n','x','exp(x)');
% fprintf(fileID,'%6.2f %12.8f\n',A);
% fclose(fileID);
% save('test.txt', 'string');

% prepare the Fourier transform
fourTime = (0:pnts-1)/pnts; 
fCoefs   = zeros(size(signal));

for fi=1:pnts
    
    % create complex sine wave
    csw = exp( -1i*2*pi*(fi-1)*fourTime );
    if(fi-1 == 1)
        partial = signal.*csw;
    end
    % compute dot product between sine wave and signal
    fCoefs(fi) = sum(signal.*csw ) / pnts;
    % these are called the Fourier coefficients
end

% extract amplitudes
ampls = 2*abs(fCoefs);

% compute frequencies vector
hz = linspace(0,srate/2,floor(pnts/2)+1);
hz2= srate* (0:pnts/2)/pnts;







figure(1), clf
subplot(211)
plot(time,signal,'k','linew',2)
xlabel('Time (s)'), ylabel('Amplitude')
title('Time domain')

subplot(212)
stem(hz,ampls(1:length(hz)),'ks-','linew',3,'markersize',15,'markerfacecolor','w')

% make plot look a bit nicer
set(gca,'xlim',[0 10],'ylim',[-.01 3])
xlabel('Frequency (Hz)'), ylabel('Amplitude (a.u.)')
title('Frequency domain')
%% Matlab FFT function

% fCoefsF = fft(signal)/pnts;
% amplsF  = 2*abs(fCoefsF);
% hold on
% plot(hz,amplsF(1:length(hz)),'ro','markerfacecolor','r')


%% my DFT implementation
% fCoefsF = myDFT(signal)/pnts;
% amplsF  = 2*abs(fCoefsF);
% hold on
% plot(hz,amplsF(1:length(hz)),'ro','markerfacecolor','r')


%% my FFT implementation

fCoefsF = myFFT(signal)/pnts;
amplsF  = 2*abs(fCoefsF);
hold on
plot(hz,amplsF(1:length(hz)),'ro','markerfacecolor','r')