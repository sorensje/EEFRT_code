% cd 'C:\Users\Jim\Documents\My Dropbox\'
addpath('~/Dropbox/EEfRT for grant/')
% cd '/Users/Jim/Dropbox/EEfRT for grant/EEFRT_data_06302014'
cd '/Users/Jim/Dropbox/PACO_JS/EEfRT_analysis/eefrt_data_network_nov_2014'

clear
files=dir('*.mat');

for ii =1:numel(files)
   inputfile=files(ii,1).name;
   outputfile=regexprep(files(ii,1).name,'.mat','.txt');
   try
       Rfilewriter_EEfRT3(inputfile,outputfile)
   catch
       inputdata2 = load(inputfile);
       inputdata=inputdata2.uber;
       varnames=fieldnames(inputdata);
       length(varnames)
       size(inputdata,2)
       clear varnames inputdata inputdata2 
   end
end



%%% problem files
% dataStruct_2687_LOSS.mat