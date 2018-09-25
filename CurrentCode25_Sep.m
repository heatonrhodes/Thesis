clear all
%Import the file(s)
file1 = 'Scaled Shaker direct 800Hz Bbox 2.flac';

%Set the number of times to cut up the time domain signal for separate
%processing and averaging in the frequency domain.
%having z as a power of 2 (2,4,8,16) seems to yield the best results, some
%signals become distorted when cut.

%he more times the signal is cut, the shorter each signal is in the time
%domain. This reduces the quality of each FFT so slicing up the signal too
%many times is not reccommended.

%Set z = 1 if no slicing is wanted.
z = 1;

%Import the file. y is the data and fs is the sample rate.
[y,fs] = audioread(file1);

%Data from the bluebox comes in 3 channels (x,y,z). We want only Z.
%The conditional statement allows code to be used interchangeably for
%signals from the piezo as well.
if size(y,2)>1
    y = y(:,3);
    
    %This line removes the offset. It could be done using a highpass filter
    %however this is far more efficient
    y = y - mean(y);
end

%This cuts the end of the time domain signal if the signal is not divisible
%by z. If this does not happen MATLAB will not be able to rearrange the
%signal into z parts. If z = 1 nothing will happen.
if mod(length(y),z)~=0
    red = mod(length(y),z);
    y = (1:length(y)-red);
end

%This cuts the signal into z slices and places them into a matrix
y = reshape(y,length(y)/z,z);

%A hanning window is applied to each signal.
filtered = hanning(length(y)).*y;

%set the length on the fft to the sample rate. This yields good resolution
%and ensures the resolution of the fft is constant between data samples (as
%MEMS actual sample rate changes). It also ensures the resolution of the
%fft is constant even when the lengths of the recordings are not exactly the
%same (as may occur when using nextpow2). I tried using nextpow2 however
%the increased resolution actually made the data less readable and was
%counterproductive.

%The length of fft being the sample rate also ensures there are the same 
%number of points in the fft between 0 and 1500 (average nyquist frequency
%of the MEMS) for piezo and MEMS data, as the nyquist of the
%piezo is higher (as the piezo fft continues to roughly 8000Hz).
n = fs;

%Take the fft. The third argument (1) sets the direction for the fft. This is
%used when z>1 and the data is a matrix.
x = fft(filtered,n,1);

%Take the magnitude as some ffts have complex values
X = abs(x);

% When z = 1 the following statements do not do anything, however are 
%placed in an if statement to reduce computations & processing time
if z > 1
    % The data is divided by z^2 as cutting the signal changes the magnitude.
    X = X./(z^2);
    
    %Take the average of each point across the z ffts. X is now a single column
    %vector.
    X = mean(X,2);
end

%construct the frequency vector for plotting
freq = 0:fs/length(X):fs/2;

%Cut the fft in half to remove the symmetric side
X = X(1:floor(length(X)/2+1));

%convert to dB for plotting
FFTdata = mag2db(X);



%Plot
plot(freq,FFTdata);
title(file1)
xlim([0,1500]);
xlabel('Frequency (Hz)');
ylabel('Magnitude dB (g re 1g)');
legend('MEMS');

