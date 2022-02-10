function [ values ] = acquireImageDetails( info, desiredFields, istime )
    %ACQUIRE IMAGE DETAILS
    if nargin < 3
        istime = 0;
    end

    if istime
        %values = nan*ones(3,length(desiredFields));
        values = [];
    else
        values = nan*ones(1,length(desiredFields));
    end    

    if (isfield(info(1),'ImageDescription'))
        state = info(1).ImageDescription;
        %state = strread(state,'%q');
        state = strread(state,'%s',-1,'delimiter','\n');
        
        for ii = 1:length(state)
            %for jj = find(isnan(values(1,:)))
            for jj = 1:length(desiredFields)
                if (~isempty(strfind(state{ii},desiredFields{jj})))
                   eInd = strfind(state{ii},'=');
                   val = state{ii}(eInd+1:end);
                   val(strfind(val,'''')) = [];
                   
                   if istime
                       t = datetime(val,'Format','MM/dd/yyyy HH:mm:ss.SSS');
                       values = [values,t];

%                        val = strread(val,'%s');
%                        val = strread(val{end},'%s',-1,'delimiter',':');
%                        values(:,jj) = str2double(val);
                   else                       
                       values(jj) =  str2num(val);
                   end
                end
            end
        end
    end
    
end

