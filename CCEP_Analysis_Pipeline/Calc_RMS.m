function y = Calc_RMS(a,TimeInterval)
% Function to calculate root mean square

% Input: A

%        TimeInterval:

% Output: Raw TMS value
    x=0;
    for i=15:300
        x = x+a(i)^2
    end
    y=x/286;
    y=sqrt(y);   
end

