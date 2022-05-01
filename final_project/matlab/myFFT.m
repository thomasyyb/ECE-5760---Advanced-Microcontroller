function coeff = myFFT(signal)
    N = length(signal);
    for k = 1:N
        coeff(k) = myFFTHelper(signal, k-1);
    end


end

function sum = myFFTHelper(signal, k)
    N = length(signal);
    sum = 0;
    if(N == 0)
        sum = 0;
    elseif(N == 1)
        sum = signal;
    else
        evenSignal = signal(1:2:end);
        oddSignal = signal(2:2:end);
        sumEven = myFFTHelper(evenSignal, k);
        sumOdd = myFFTHelper(oddSignal, k);
        sum = sumEven + sumOdd*exp(-1j*2*pi*k/N);
    end

end
