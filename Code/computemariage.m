function couple = computemariage(ssd,Npc)
% Couple(i,1) = j, best i right to j
% Couple(i,2) = j, best i bottom of j
men = 1:Npc;
[~, I] = sort(ssd(:,:,2),2);
women = mat2cell(I,ones(size(men)));
couple = zeros(size(men,2),4);
while ~isempty(men)
    candidate = men(1);
    men = men(2:end);
    wife = women{candidate}(1);
    women{candidate}(1) = [];
    if couple(wife,2) == 0
        couple(wife,2) = candidate;
    else
        enemy = couple(wife,2);
        if ssd(wife,candidate,1) < ssd(wife,enemy,1)
            couple(wife,2) = candidate;
            men = [men enemy];
        else
            men = [men candidate];
        end
    end
end
couple(:,2) = couple(couple(:,2));

men = 1:Npc;
[~, I] = sort(ssd(:,:,4),2);
women = mat2cell(I,ones(size(men)));
while ~isempty(men)
    candidate = men(1);
    men = men(2:end);
    wife = women{candidate}(1);
    women{candidate}(1) = [];
    if couple(wife,4) == 0
        couple(wife,4) = candidate;
    else
        enemy = couple(wife,4);
        if ssd(wife,candidate,3) < ssd(wife,enemy,3)
            couple(wife,4) = candidate;
            men = [men enemy];
        else
            men = [men candidate];
        end
    end
end
couple(:,4) = couple(couple(:,4));

men = 1:Npc;
[~, I] = sort(ssd(:,:,1),2);
women = mat2cell(I,ones(size(men)));
while ~isempty(men)
    candidate = men(1);
    men = men(2:end);
    wife = women{candidate}(1);
    women{candidate}(1) = [];
    if couple(wife,1) == 0
        couple(wife,1) = candidate;
    else
        enemy = couple(wife,1);
        if ssd(wife,candidate,2) < ssd(wife,enemy,2)
            couple(wife,1) = candidate;
            men = [men enemy];
        else
            men = [men candidate];
        end
    end
end
couple(:,1) = couple(couple(:,1));

men = 1:Npc;
[~, I] = sort(ssd(:,:,3),2);
women = mat2cell(I,ones(size(men)));
while ~isempty(men)
    candidate = men(1);
    men = men(2:end);
    wife = women{candidate}(1);
    women{candidate}(1) = [];
    if couple(wife,3) == 0
        couple(wife,3) = candidate;
    else
        enemy = couple(wife,3);
        if ssd(wife,candidate,4) < ssd(wife,enemy,4)
            couple(wife,3) = candidate;
            men = [men enemy];
        else
            men = [men candidate];
        end
    end
end
couple(:,3) = couple(couple(:,3));