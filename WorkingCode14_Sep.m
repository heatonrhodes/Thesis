clear all
%Import the file
%filename = 'Bluebox-1kHz-magnet-2.flac';
filename = '1kHz with BNK.flac';
%y =  data, fs = sample rate
[y,fs] = audioread(filename);
y=y.*256;
%apply hanning window
bbx = hanning(length(y(:,3))).*y(:,3);
%For no window;
%bbx = y(:,3);

%Take fft of 3rd channel (Z, vertical)
Bbox = fft(bbx,fs);
% I'll assume y has even length
Bbox = Bbox(1:length(Bbox)/2+1);
% create a frequency vector
%freq = 0:fs/length(y):fs/2;
freqBbox = 1:length(Bbox);
fsBbox = fs;


filename = 'Piezo-1kHz-magnet-2.flac';
%filename = '1kHz with BNK.flac';
%y =  data, fs = sample rate
[y,fs] = audioread(filename);

%This line cuts the piezo data to the same number of samples as the bluebox
%y = y(1:length(Bbox));

%apply hanning window
pz = hanning(length(y)).*y;
%For no window;
%bbx = y(:,3);

Piezo = fft(pz,fs);
% I'll assume y has even length
Piezo = Piezo(1:length(Piezo)/2+1);
%Cut Piezo to be same length as Bbox
Piezo = Piezo(1:length(Bbox));
% create a frequency vector
%freq = 0:fs/length(y):fs/2;
freqPiezo = 1:length(Piezo);

%Plot in dB
plot(freqPiezo,mag2db(abs(Piezo)),'r',freqBbox,mag2db(abs(Bbox)),'b');
%Plot regular log y axis
%semilogy(freqPiezo,abs(Piezo),'r',freqBbox,abs(Bbox),'b');

title('Bluebox vs Piezo 1kHz')
xlim([0,fsBbox/2]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('Piezo','Bluebox');

