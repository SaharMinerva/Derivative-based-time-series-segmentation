%%
%     COURSE: Master MATLAB through guided problem-solving
%    SECTION: Segmentation
%      VIDEO: Derivative-based time series segmentation
% Instructor: mikexcohen.com
%
%%

% random smooth time series
N = 1000; % days
tv = (0:N-1)/30;
gwin = exp( -zscore(tv).^2/.0001 );

% "stock market": smoothed noise plus linear trend
signal = conv(cumsum(randn(N,1)),gwin,'same') + linspace(-100,100,N)';


% compute derivative
signalD = diff(signal); %the discrete version of the derivative is the difference , it will be of length N-1
signalD(N) = signalD(end); 


% pick some threshold based on normalized derivative
figure(1), clf
hist(zscore(signalD),150) ;% we have the zscore because we want to derive the threshold from the distribution rather than 
%a certain numberical value 

% select threshold (standard deviation units)
zthresh = 1.7 % visual inspection 

% find extreme derivative points up and down
deriv_hi = find(zscore(signalD) > zthresh) ; %without find it will give us a boolean. 'find function' gets the actual values
deriv_lo = find(zscore(signalD) < -zthresh) ;

% create new time series of NaN's with selected time points
jumpUp = nan(N,1);
jumpUp(deriv_hi) = signal(deriv_hi);


jumpDn = nan(N,1);
jumpDn(deriv_lo) = signal(deriv_lo);



% plot
figure(2), clf, hold on
plot(tv,signal,'k')
plot(tv,jumpUp,'g','linew',3)
plot(tv,jumpDn,'r','linew',3)

set(gca,'xlim',tv([1 end]),'xtick',0:6:max(tv),'ytick',[])
legend({'"Stock market"';'Good times';'Bad times'})
xlabel('Time (months)'), ylabel('Market value')
title([ 'Stock market values with shifts of ' num2str(zthresh) 'std indicated.' ])

zoom on


%%
