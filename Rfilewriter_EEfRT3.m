function Rfilewriter_EEfRT3(inputfile, outputfile)

% inputfile='dataStruct_2672_LOSS.mat';
% outputfile='dataStruct_2672_LOSS.txt'; % doesn't work!
inputdata_temp = load(inputfile);

inputdata=inputdata_temp.uber;
varnames=fieldnames(inputdata);
n_vars=length(varnames);
ntrials=size(inputdata,2);

outfile = fopen(outputfile, 'wt');
fprintf(outfile,[sprintf('%s\\t',varnames{3:end-1}),varnames{end}, '\n']); %write varnames as column headings

% ntrials=4;
% n_vars=10;

for ii = 1:ntrials
    outline=[];
    entry=[];
    ent2write=[];
    for jj =3:(n_vars) %not timing or trial keys
        entry=inputdata(1,ii).(varnames{jj});
%         echo(entry)
%         obj=class(entry)
        if (iscell(entry))
            ent2write=char(entry);
        elseif (isnumeric(entry))
           ent2write=num2str(entry); 
        elseif (ischar(entry))
            ent2write=entry;
        end
        if (jj<n_vars)
            outline = strcat(outline, sprintf('%s\\t',ent2write));
        else
            outline =strcat(outline,sprintf('%s\\n',ent2write));
        end
    end
    fprintf(outfile, outline, '%s'); 
end
    fclose(outfile);
end
