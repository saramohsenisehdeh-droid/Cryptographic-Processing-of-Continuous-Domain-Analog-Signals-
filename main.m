% You should change the current folder to the folder-
% where the project file is located so that you don't get the error.
clc
clear
close all


%%%%%%%%%%%%%%%%%%%%%
%% in this part, we load the sound file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y , fs]    = audioread('testmusic.wav');
load("filters.mat")

%player      = audioplayer(y , fs);

%play the sound
%play(player)

%%%%%%%%%%%%
%define matrix A
A           = [ 0   0   1   0   0 ; ...
                0   0   0   0   1 ; ...
                0   0   0   1   0 ; ...
               .05  0   0   0   0 ; ...
                0   1   0   0   0];

%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You have to fill in this part    |   |          %
%                                  |   |          %
%                                 \     /         %
%                                  \   /          %
%                                   \ /           %
%                                    .            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% computing the inverse matrix
% you should descramble band acording to inverse matrix
%%%%%%%%%%%%%%%%%%%%%%%%%
Ainv        = inv(A);
disp(Ainv)

%% spectrum of sound
%%%%%%%%%%%%%%%%%%%%%%%%%
% use FFT function defined in example
figure;
Z = FFT(y,fs);title('y(encoded signal)')
%% decomposing the input into 5 bands
%%%%%%%%%%%%%%%%%%%%%%%%%
soundFourier = Z;

%% Band1
y1      = y;
y1      = filter(Band1,y1);

%% Band2
y2      = y;
y2      = filter(Band2,y2);

%% Band3
y3      = y;
y3      = filter(Band3,y3);

%% Band4
y4      = y;
y4      = filter(Band4,y4);

%% Band5
y5      = y;
y5      = filter(Band5,y5);


n = 1:length(y);

y1s=cos(8820/fs*2*pi*n) .* y1';
y2s=cos(13230/fs*2*pi*n) .* y2';
y3s=cos(4410/fs*2*pi*n) .* y3';
y4s= 20 * cos(13230/fs*2*pi*n) .* y4';
y5s=cos(13230/fs*2*pi*n) .* y5';
x1 = filter(Band3, y1s);
x2 = filter(Band5, y2s);
x3 = filter(Band4, y3s);
x4 = filter(Band1, y4s);
x5 = filter(Band2, y5s);
%%%%%%%Draw and examine
figure;
subplot(3,1,1)
FFT(y1,fs);
title('y1');
subplot(3,1,2)
FFT(y1s,fs);
title('shifted y1')
subplot(3,1,3)
FFT(x1,fs);
title('filtered shifted y1')
%%%%
figure;
subplot(3,1,1)
FFT(y2,fs);
title('y2');
subplot(3,1,2)
FFT(y2s,fs);
title('shifted y2')
subplot(3,1,3)
FFT(x2,fs);
title('filtered shifted y2')
%%%%
figure;
subplot(3,1,1)
FFT(y3,fs);
title('y3');
subplot(3,1,2)
FFT(y3s,fs);
title('shifted y3')
subplot(3,1,3)
FFT(x3,fs);
title('filtered shifted y3')
%%%%
figure;
subplot(3,1,1)
FFT(y4,fs);
title('y4');
subplot(3,1,2)
FFT(y4s,fs);
title('shifted y4')
subplot(3,1,3)
FFT(x4,fs);
title('filtered shifted y4')
%%%%
figure;
subplot(3,1,1)
FFT(y5,fs);
title('y5');
subplot(3,1,2)
FFT(y5s,fs);
title('shifted y5')
subplot(3,1,3)
FFT(x5,fs);
title('filtered shifted y5')
figure
All(x1,x2,x3,x4,x5,fs);
figure
All(y1,y2,y3,y4,y5,fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    .            %
%                                   / \           %
%                                  /   \          %
%                                 /     \         %
%                                  |   |          %
%                                  |   |  length(y)*        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
% check whether the decompositon is ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x       = x1 + x2 + x3 + x4 + x5;
figure
FFT(x,fs);
title('x - decoded (original) signal')
%%
player  = audioplayer(x , fs);
%play(player)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%save vector x as a sound in the curent folder
audiowrite('output.wav' , x , fs)



%% Functions:
function M = FFT(m , fs) 
M = fftshift(fft(m)); N=numel(m) ;
freq = (-N/2:N/2-1)/N*fs; % figure
plot(freq , (abs(M)) , 'LineWidth' , 1) ; grid on
ylabel ('AMP')
xlabel ('Freq(Hz)')
end

function M = All(m1,m2,m3,m4,m5 , fs) 
M1 = fftshift(fft(m1)); N=numel(m1) ;
M2 = fftshift(fft(m2)); N=numel(m2) ;
M3 = fftshift(fft(m3)); N=numel(m3) ;
M4 = fftshift(fft(m4)); N=numel(m4) ;
M5 = fftshift(fft(m5)); N=numel(m5) ;
freq = (-N/2:N/2-1)/N*fs; % figure
plot(freq , (abs(M1)) ,'g', 'LineWidth' , 1) ; grid on
hold on
plot(freq , (abs(M2)) ,'r', 'LineWidth' , 1);
hold on 
plot(freq , (abs(M3)) ,'b', 'LineWidth' , 1);
hold on 
plot(freq , (abs(M4)) ,'c', 'LineWidth' , 1);
hold on 
plot(freq , (abs(M5)) ,'b', 'LineWidth' , 1);
ylabel ('AMP')
xlabel ('Freq(Hz)')
% xlim([0,fs/2]) 
end