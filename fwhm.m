function [fwhm, i0] = fwhm(t, It)
% FWHM normalizes the input intensity profile, but does not subtract the
% background.  'fwhm' is the full-width-half-max of the given profile It in
% the 't' domain.  FWHM finds the 50% point on either side of the
% normalized profile.  'i0' is the index of the cell in the middle of the
% FWHM.

% clear all
% close all
% 
% load ('\\erc-b212-server\Group Files\domingue\data\072910\072910c')
% It = Spectrum; t = SpecAxis;
% 
% n = length(Im);
% m = (-Im(n) + Im(1))/(-lm(n) + lm(1));
% b = Im(1) - m*lm(1);
% Im = Im - (m*lm + b); Im = Im./max(Im);
% It = Im; t = lm;

%% Left side of peak
allowed_err = 0.001;

It = It./max(It);
[temp, imax] = max(It); t2 = imax;
t1 = 1;

counter = 1;
while counter < imax;
    t3 = round((t2+t1)/2);
    err = (It(t3)-0.5)/0.5;
    if t2 == t1 + 1
        break 
    elseif It(t3)>0.5
        t2 = t3;
    else 
        t1 = t3;
    end
    counter = counter+1;
end
i_left = t1; 

if (0.5 - It(t1)) < allowed_err
    t_left = t(t1);
else
    n = round((It(t2) - It(t1))/0.5/allowed_err);
    t_ = linspace(t(t1), t(t2), n);
    It_ = interp1(t(t1:t2), It(t1:t2), t_);
    
    err = 1; t1 = 1;  t2 = n;
    while abs(err)>allowed_err+0.001
        t3 = round((t2+t1)/2);
        err = (It_(t3)-0.5)/0.5;
        if err > 0
            t2 = t3;
        else
            t1 = t3;
        end
    end
    t_left = t_(t3);
end

%% Right Side of peak
t1 = imax; t2 = length(t);
counter = 1;
while counter < length(t)-imax;
    t3 = round((t2+t1)/2);
    err = abs(It(t3)-0.5)/0.5;
    if t2 == t1 + 1
        break 
    elseif It(t3)>0.5
        t1 = t3;
    else 
        t2 = t3;
    end
    counter = counter + 1;
end
i_right = t1;

if (0.5-It(t1)) < allowed_err
    t_right = t(t1);
else
    
    n = round((It(t1) - It(t2))/0.5/allowed_err);
    t_ = linspace(t(t1), t(t2), n);
    It_ = interp1(t(t1:t2), It(t1:t2), t_);
    
    err = 1; t1 = 1;  t2 = n;
    while abs(err)>allowed_err+0.001
        t3 = round((t2+t1)/2);
        err = (It_(t3)-0.5)/0.5;
        if err > 0
            t1 = t3;
        else
            t2 = t3;
        end
    end
    t_right = t_(t3);
end
%% final result
fwhm = abs(t_right - t_left);
i0 = round((i_right + i_left)/2);