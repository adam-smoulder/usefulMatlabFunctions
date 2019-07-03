function [dateTimeString] = grabDateTimeString()
%%% Very quick function just to get a simple datetime string to be used for
%%% appending to filenames
%%%
%%% Adam Smoulder, 9/10/18
%%%

thedate = date;
time = clock;
dateTimeString = [thedate num2str(time(4)) num2str(time(5)) num2str(round(time(6)))];

end

