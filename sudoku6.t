% Note to self:
% working (Row,col,possibility)
% Row is y      locate(col,row)
% Col is x
% Possibility 0 ======> means no posibility
% Possibility 1 ======> Could be that number
% Possibility 2 ======> Means it is that number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setscreen ("graphics:400,360")      % set the screen to the size
var working : array 1 .. 9, 1 .. 9, 1 .. 9 of int   % Working array
var final : array 1 .. 9, 1 .. 9 of int % Final array
var count : int := 0    % How many numbers are there
var posCount := 0       % how many possibility were there
var onlyPos := 0        % save the possibility
%%%% File open variables
var streamNum : int
var fileName, num : string := ""
proc initaPossibility   % If there is a number already then remove all its posibility
    for row : 1 .. 9
	for col : 1 .. 9        % IF there is a number
	    if final (row, col) not= 0 then
		for posi : 1 .. 9  % Set all the posiblity to 0 in that col,row
		    working (row, col, posi) := 0
		    working (row, col, final (row, col)) := 2
		end for
	    end if
	end for
    end for
end initaPossibility
procedure crossOut (x, y, pos : int)
    var minX, minY : int := 0
    for x1 : 1 .. 9 %Cross all x ## ->> on that y axis
	working (x1, y, pos) := 0   % No possibility
    end for
    for y1 : 1 .. 9   %Cross all y ## ->> on that x axis
	working (x, y1, pos) := 0
    end for
    % Find out when to start from
    % Find x
    if x >= 1 and x < 4 then    % Range 1 ..3
	minX := 1               % X is start from 1
    elsif x >= 4 and x <= 6 then
	minX := 4
    elsif x > 6 and x <= 9 then
	minX := 7
    end if
    % Find y
    if y >= 1 and y < 4 then       % Range 1 ..3
	minY := 1                  % Y is start from 1
    elsif y >= 4 and y <= 6 then
	minY := 4
    elsif y > 6 and y <= 9 then
	minY := 7
    end if
    % box
    for x1 : minX .. minX + 2       % x .. 2
	for y1 : minY .. minY + 2   % y .. 2
	    working (x1, y1, pos) := 0  % NO possibility
	end for
    end for
    working (x, y, pos) := 2     % Re-initalize the number is 2
    final (x, y) := pos          % Saving it to final array
end crossOut

put "What file do you want to open? " ..
locate (2, 1)
get fileName

open : streamNum, fileName, get
if streamNum < 1 then
    put "Error upon openning " ..
else
    for x : 1 .. 9
	get : streamNum, num
	for y : 1 .. 9
	    for k1 : 1 .. 9             % Initalize everything to zero
		working (x, y, k1) := 1
	    end for
	    % When the number is not 0 then set
	    if strint (num (y)) > 0 then             % If is given
		working (x, y, strint (num (y))) := 2
		final (x, y) := strint (num (y))
	    else
		final (x, y) := 0             % Inital
	    end if
	end for
    end for
    close : streamNum           % Close the file

    initaPossibility    % initalize from final to working array
    loop
	exit when count = 81 % If is 81 then is done
	count := 0          % Reset
	for x : 1 .. 9   % Check count
	    for y : 1 .. 9 % Check count
		for pos : 1 .. 9 % Check Count
		    if working (x, y, pos) = 2 then % When a number is found
			crossOut (x, y, pos) % Cross out that possibility
			count += 1          % Increment number found
		    elsif working (x, y, pos) = 1 then % If there is a possibility
			posCount += 1       %  How many possibility
			onlyPos := pos      %  Save what possibility
		    end if
		end for
		if posCount = 1 then % There is only 1 number
		    crossOut (x, y, onlyPos) % Cross out that possibility on other places
		end if
		posCount := 0               % Reset
	    end for
	end for
    end loop
    % Output resolute
    put "Solution: "
    put ""
    for x : 1 .. 9
	for y : 1 .. 9
	    put final (x, y) ..
	end for
	put " "
    end for
end if



