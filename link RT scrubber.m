
%% setup
% cd 'C:\Users\Jim\Documents\My Dropbox\EEfRT for grant\EEfRT_5202013'
% cd '/Users/Jim/Dropbox/EEfRT for grant/EEfRT_5202013' %mac version
% cd /Users/Jim/Dropbox/EEFRT_analysis/PACO' EEfRt data '/
addpath('/Users/Jim/Dropbox/PACO_JS/EEfRT_analysis/EEFRT_code/');
cd /Users/Jim/Dropbox/EEfRT' for grant'/EEFRT_data_06302014 ;


% clear
files=dir('*.mat');
%% debugging vars
ii=5;
inputfile='dataStruct_2688_WIN.mat';
outputfile='EfRT_sub_2680_WIN.csv';

%%

for ii =1:numel(files)
   inputfile=files(ii,1).name;
   subnum=inputfile(regexp(inputfile,'[\d\d\d\d+]'));
   lwin=[regexp(inputfile,'LOSS','match') regexp(inputfile,'WIN','match')];
   outputfile=strcat('Effrt_RT_sub_',num2str(subnum),'_',char(lwin),'.csv');
   try
       outdat=trialkeyscrubber(inputfile);
       struct2csvJS(outdat,outputfile);
   catch
       inputdata2 = load(inputfile);
       inputdata=inputdata2.uber;
       varnames=fieldnames(inputdata);
       length(varnames);
       size(inputdata,2);
       clear varnames inputdata inputdata2 
   end
end

