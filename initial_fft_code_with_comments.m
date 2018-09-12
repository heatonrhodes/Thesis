%Import the file
filename = '1 kHz.flac';
%y =  data, fs = sample rate
[y,fs] = audioread(filename);

%Take fft of 3rd channel (Z, vertical)
ydft = fft(y(:,3));

%The below code I borrowed from stack exchange to get the vectors to line
%up and make it plottable. I didnt exactly understand why it cut the
%reading in half after it took the fft but it seemed to work correctly 
%for the piezo signals so I continued to use it.
%-----------
% I'll assume y has even length
ydft = ydft(1:length(y)/2+1);
% create a frequency vector
freq = 0:fs/length(y):fs/2;
%-----------

%plot magnitude
subplot(2,1,1);
plot(freq,abs(ydft));
%for log axis use ----> %semilogx(freq, abs(ydft));
%I have been using linear axis as bandwidth is quite low 
%(sampling rate=3200) so log axis reduces readability while
%practicing/diagnosing

%Edit graph to make it more readable. There is a huge spike at f = 0 so
%makes the y axis unreadable unless you limit it
ylim([0,1]);
%xlim([0,1500]); %BNK plots much higher frequencies so limit to same as
%bluebox
title('0.5 kHz Bluebox measurement')
xlabel('Hz');