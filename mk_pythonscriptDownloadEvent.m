clear


%% script to atumatically download data using the USGS mail informations
disp('try to input the t0 of the event instead...')
%% provide the information from USGS catalog alert mail
timeBeforeEvent=5; %in minutes
timeAfterEvent = 30; %in minutes

% this should be parsed automatically from the mail
year = 2015;
month=7;
day= 29;
t0hour=2;
t0min=35;
t0sec=58;
lat=59.897;
lon=153.072;
depth=118;
mag=6.3;
region='ALASKA';

%% here build t0 and t1 string to put on the script



T0 = datenum([year,month,day,t0hour,t0min,t0sec]);
t0 = addtodate(T0,-timeBeforeEvent,'minute');
t1 = addtodate(T0,timeAfterEvent,'minute');

formatOut = 'yyyy-mm-ddTHH:MM:SS';

startime = datestr(t0,formatOut);
endtime = datestr(t1,formatOut);

%% make the script to download data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   f = fopen(['getData.sh'], 'at');
   
   fprintf(f,['obspyDMT --continuous --datapath \''' char(startime) '\'' --min_date \''' char(startime) '.000000Z\'' --max_date \''' char(endtime) '.000000Z\'' --net \''_GSN\'' --arc \''N\'' --cha \''BHZ\'' --pre_filt \''(0.005,0.006,40,41)\'' --corr_unit \''DIS\''\n']);
   
   fclose(f);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% made or update the catalog 

if exist('catalogUSGS.list')==0
f = fopen(['catalogUSGS.list'], 'at');
% make the header for the catalog
fprintf(f,'t0+time before lat lon depth mag region time bef. time aft. \n')
fclose(f)
end

f = fopen(['catalogUSGS.list'], 'at');
fprintf(f,[char(startime) ' ' num2str(lat) ' ' num2str(lon) ' ' num2str(depth) ' ' num2str(mag) ' ' char(region) '  ' int2str(timeBeforeEvent) ' ' int2str(timeAfterEvent) '\n'])
fclose(f);



