clear
clc

% This srcipt parse the data downloaded with obsoyDMT
% It requires taup installed!!!!

addpath /src

% freuency band of data

FB = [.005 5];
ordeFilter=3;
newTau = 0.05;

SNRlimit = 5;

distanceRange=[32 88];

% script to parse data and save the SAC in mat structure

%% read the catalog

[s.date, s.lat, s.lon, s.depth, s.mag , s.region, s.beforeEvent, s.afterEvent]=textread('catalogUSGS.list','%s %f %f %f %f %s %f %f%*[^\n]','headerlines',1);

%% make the file to parse the data

D = dir(char(s.date));
direc = [char(s.date) '/' char(D(3,1).name) '/continuous1/BH'];

system(['ls ' char(direc) '> list'])

[list]=textread('list','%s %*[^\n]');


%% make the directory to save the data

mkdir(['matData/' char(s.date) '_M' num2str(s.mag) '_' char(s.region) '_mat'])


for i1 = 3 : length(list)
    
   %% load sac
   data = readsac([char(direc) '/' char(list(i1))]);
    
   % check data have the right amount of time staored
   
   if data.npts > s.afterEvent*30/data.tau
   
   %% get the distance
   [data.dist,data.az] = distance(s.lat,s.lon,data.slat,data.slon);
   
   if data.dist>min(distanceRange) && data.dist<max(distanceRange)
   
   data.distkm=deg2km(data.dist);
   data.elat=s.lat;
   data.elon=s.lon;
   data.edep=s.depth;
   data.magnitude=s.mag;
   data.region=s.region;
   data.timeBeforeEvent=s.beforeEvent*60;
   data.timeAfterEvent=s.afterEvent*60;
   %% get the travel time of the first arrival
   [tP,qP] = TravelTimeTaupPhasesDistance(data.dist,'ttp+',data.edep);
   
   data.PwavefluxArrivals=qP;
   
   [tS,qS] = TravelTimeTaupPhasesDistance(data.dist,'tts+',data.edep);

   data.SwavefluxArrivals=qS;
   
   %% filter the data
   [a1,b1]=butter(ordeFilter,FB*2*data.tau); 
   data.FB=FB; 
   data.ordeFilter=ordeFilter;
    
   data.trace=filtfilt(a1,b1,data.trace); 
    
   % plot
   plot(data.trace)
   hold on
   plot(min(tP)/data.tau+data.timeBeforeEvent/data.tau,0,'or')
   plot(min(tS)/data.tau+data.timeBeforeEvent/data.tau,0,'ok')

   clear tP tS qP qS
   
   % check SNR
   
   signal = data.trace(round((min(data.PwavefluxArrivals.time)-30+data.timeBeforeEvent)/data.tau):round((min(data.PwavefluxArrivals.time)+60+data.timeBeforeEvent)/data.tau));
   noise =  data.trace(round((min(data.PwavefluxArrivals.time)-100+data.timeBeforeEvent)/data.tau):round((min(data.PwavefluxArrivals.time)-60+data.timeBeforeEvent)/data.tau));
    
   data.SNR = max(abs((signal)))/rms(noise);
   

   if data.SNR > SNRlimit
   % resample the data
   
   
   disp('make interpolation')
   T=(0:data.tau:(length(data.trace)-1)*data.tau);
      
   newT=(0:newTau:(length(data.trace)-1)*data.tau);

      
   % interpolate the trace
      
   data.trace = interp1(T,data.trace,newT,'spline');
   data.tau=newTau;
   timevec = newT - (data.timeBeforeEvent);
   data.timeVector = timevec;
   % save
   eval(['save matData/' char(s.date) '_M' num2str(s.mag) '_' char(s.region) '_mat/' char(data.staname) '_' char(data.kcomp) '.mat data'])
   
   clear data
   close
   
   else
   disp('SNR too low')
   end
   else
   disp('no data in the selected range of distances') 
   end
   
   
   else
   disp('the data SAC are too short')
   end

end