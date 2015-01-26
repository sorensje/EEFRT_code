function struct2csvJS(s,fn)
% STRUCT2CSV(s,fn)
%
% JS edit: flip fields if need be
% 
% 
% Output a structure to a comma delimited file with column headers
%
%       s : any structure composed of one or more matrices and cell arrays
%      fn : file name
%
%      Given s:
%
%          s.Alpha = { 'First', 'Second';
%                      'Third', 'Fourth'};
%
%          s.Beta  = [[      1,       2;
%                            3,       4]];
% 
%      STRUCT2CSV(s,'any.csv') will produce a file 'any.csv' containing:
%
%         "Alpha",        , "Beta",
%         "First","Second",      1,  2
%         "Third","Fourth",      3,  4
%
% Written by James Slegers, james.slegers_at_gmail.com
% Covered by the BSD License
%




FID = fopen(fn,'w');
headers = fieldnames(s);
m = length(headers);
l = '';

 for (ii = 1:size(headers,1))
        howbig=size(s.(headers{ii}));
    if (howbig(1)==1 && howbig(2)>1)
        s.(headers{ii}) = s.(headers{ii})';
    end
 end
 
for ii = 1:m
    sz(ii,:) = size(getfield(s,headers{ii}));
    l = [l,'"',headers{ii},'",'];
    if sz(ii,2)>1
        for jj = 2:sz(ii,2)
            l = [l,','];
        end
    end
end
l = [l,'\n'];
fprintf(FID,l);

n = max(sz(:,1));

for ii = 1:n
    l = '';
    for jj = 1:m
        for kk = 1:sz(jj,2)
            if sz(jj,1)<ii
                str = [','];
            else
                c = getfield(s,headers{jj});
                if isnumeric(c)
                    str = [num2str(c(ii,kk)),','];
                else
                    str = ['"',c{ii,kk},'",'];
                end
            end
            l = [l,str];
        end
        
    end
    l = [l,'\n'];
    fprintf(FID,l);
end
fclose(FID);
