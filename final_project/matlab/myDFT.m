
function coeff = myDFT(signal)
    coeff = [];
    N = length(signal);
    for k = 1 : N
        sum = 0;
        for n = 1 : N
            sum = sum + signal(n)*exp(-1i*2*pi*(k-1)*(n-1)/N);
        end
        coeff(k) = sum;
    end
end

%% improved version without nested for loop
% function coeff = myDFT(signal)
%     for k = 1 : 
% 
% end