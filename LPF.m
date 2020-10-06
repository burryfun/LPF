clear all;

STEP = 0.001;
% SIGNAL PARAMETERS
x = 0:STEP:1;
fd = (max(x) - min(x))/STEP;
freq = 0:1:fd;

y = 50*cos(2*pi*10*x) + 231*cos(2*pi*121*x) + 200*sin(2*pi*354*x) + 150*sin(2*pi*256*x);
% y = 10*square(2*pi*10*x) + 22*square(2*pi*54*x) + 14*square(2*pi*122*x);
% y = 5*sinc(2*pi*2*x) + 10*cos(2*pi*100*x);

subplot(2,2,1);
plot(x, y);
title('Signal');

y_FT = abs(fft(y));
subplot(2,2,2);
plot(freq, y_FT);
title('Signal spectrum');
xlim([0 fd/2]);

subplot(2,2,3);
y_LPF = FIR_LPF(y, 50, 10, fd);
title('Filtered signal');
plot(x, y_LPF);

y_LPF_FT = abs(fft(y_LPF));
subplot(2,2,4);
plot(freq, y_LPF_FT);
title('Filtered signal spectrum');
xlim([0 fd/2]);


function f = FIR_LPF(vec_y, order, fc, fd)
% FILTER PARAMETERS AND IMPULSE RESPONSE
    N = order;
    fc_n = fc/(2*fd); % magnitude cutoff frequency = 50 Hz
    h_D = zeros(1, N+1);
    for i = -N/2:1:N/2
        if i == 0
            h_D(N/2+i+1) = 2*fc_n;
        else
            h_D(N/2+i+1) = 2*fc_n * sinc(2*pi*fc_n * i);
        end
        h_D(N/2+i+1) = h_D(N/2+i+1)*1;
    end
    h_D = h_D/sum(h_D);
%     fvtool(h_D,1); % À×Õ ÔÍ×
    
% SIGNAL FILTERING
    f = zeros(1, length(vec_y));
    for i = 0:length(vec_y)-1
        f(i+1) = 0;
        for j = 0:N-1
            if i >= j
                f(i+1) = f(i+1) + h_D(j+1)*vec_y(i - j + 1);
            end;
        end
    end
end