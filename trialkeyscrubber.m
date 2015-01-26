function outdat=trialkeyscrubber(inputfile)
% requires struct2csvJS

inputdata2 = load(inputfile);
inputdata=inputdata2.uber;
varnames=fieldnames(inputdata);
n_vars=length(varnames);
ntrials=size(inputdata,2);

%% output variables
outdat.trial = zeros(1,ntrials);
outdat.medRTpress = zeros(1,ntrials);
% outdat.uniquepauses = zeros(1,ntrials);
outdat.maxrequiredinarow =  zeros(1,ntrials);
outdat.trialduration =  zeros(1,ntrials);
outdat.uniquepresses =  zeros(1,ntrials);
outdat.nmashes = zeros(1,ntrials);


%% loop through trials
% each trial is a struct inside input data. within each struct there are a 
% number of single variables, these are pulled out by the file scrubber.
% there are also two longer variables, trialkeys and timing. these are the
% buttons that the participant pressed and the timing of the press. These
% are created by each call to kbcheck in the program.  There are many
% blanks. trials with few blanks are supicious as kbcheck happens fast.
% It's tough to actually press a key and have it be recorded by sucsessive
% kbcheck calls
% 

aa=13;
for aa = 1:ntrials

    % trial specific vars
    trialsTime=inputdata(1,aa).timing;
    trialsLetter=inputdata(1,aa).trialkeys;
    answers = unique(trialsLetter);
    nrecordedkeys=size(trialsLetter,2);
   
    if inputdata(1,aa).difficulty == 'h'
        if inputdata(1,aa).dexterity == 'r'
            requiredkey = 's'; %Display this on the screen
        else
            requiredkey = 'l'; %This is used to for display purposes.
        end
    else
        if inputdata(1,aa).dexterity == 'r'
            requiredkey = 'l'; %display
        else
            requiredkey = 's'; %display
        end
    end

    % define trialdat vars. will iterate over each trial and 'collapse' data
    % will iterate through and in trial dat, create a struct that has
    % entries of each 'unique' value recorded by kbcheck.  stringcounter is 
    % the number of repetitions observed in a row. 'stringidentity' is the 
    % identity of the valueeach For instance, if 'l' was held down
    % endRepeatKbCheck is kbcheck in a trial where repeated value was
    % observed. so, for example, if there were 45 kbchecks, and a participant 
    % held down 'l' 40 times from the 3rd kbcheck to the 43 kbchec, trialdat
    % would have variables of length 3, representing 'no answer' repeated
    % twice, 'l' repeated 40 times and 'no answer' repeated twice.
    trialdat.keypresses = trialsLetter;
    trialdat.ntuple = zeros(1,nrecordedkeys);
    multipplecounter = 0;
    trialdat.stringcounter = [];
    trialdat.string_identity = {};
    trialdat.endRepeatKbCheck = [];

    for jj=2:nrecordedkeys
        if jj==nrecordedkeys % why am I doing this on the last trial, because otherwise no info recorded for last pressed button?
            multipplecounter = multipplecounter+1;
            trialdat.stringcounter = [trialdat.stringcounter multipplecounter];
            trialdat.string_identity = [trialdat.string_identity,trialdat.keypresses{jj-1}];
            trialdat.endRepeatKbCheck = [trialdat.endRepeatKbCheck jj-1];
        elseif(strcmp(trialsLetter{1,jj-1},trialsLetter{1,jj}))
            multipplecounter = multipplecounter+1;
        else
            multipplecounter = multipplecounter+1;
            trialdat.stringcounter = [trialdat.stringcounter multipplecounter];
            trialdat.string_identity = [trialdat.string_identity,trialdat.keypresses{jj-1}];
            trialdat.endRepeatKbCheck = [trialdat.endRepeatKbCheck jj-1];
            multipplecounter = 0;
        end
        trialdat.ntuple(jj)=multipplecounter;
    end

    trialdat.times=trialsTime(trialdat.endRepeatKbCheck); %when each run end

    % RT for required presses
    reqtimes=trialdat.times(strcmp(requiredkey,trialdat.string_identity));
    requireRTs=[];
    for(kk=2:size(reqtimes,2))
        timebtwnpress=reqtimes(kk)-reqtimes(kk-1);
        requireRTs=[requireRTs timebtwnpress];
    end

    %trial summary variables
%     aa
    outdat.trial(1,aa) = aa;
    outdat.medRTpress(1,aa) = median(requireRTs);
    outdat.uniquepresses(1,aa) = sum(strcmp(requiredkey,trialdat.string_identity));
    outdat.maxrequiredinarow(1,aa) = max([trialdat.stringcounter(strcmp(requiredkey,trialdat.string_identity)) 0]);
    outdat.trialduration(1,aa) = trialsTime(nrecordedkeys)-trialsTime(1);
    outdat.nmashes(1,aa) = sum(trialdat.stringcounter(strcmp(requiredkey,trialdat.string_identity))>1);
    

end
    
