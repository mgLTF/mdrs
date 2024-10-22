function [PL_data, PL_VoIP , APD , MPD , TT] = Sim3(lambda,C,f,P, n)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Packet type
DATA = 0;
VOIP = 1;

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet

%State variables:
STATE = 0;          % 0 - connection is free; 1 - connection is occupied
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS_DATA= 0;     % No. of packets arrived to the system
LOSTPACKETS_DATA= 0;      % No. of packets dropped due to buffer overflow
TOTALPACKETS_VOIP= 0;     % No. of packets arrived to the system
LOSTPACKETS_VOIP= 0;      % No. of packets dropped due to buffer overflow
TRANSPACKETS= 0;     % No. of transmitted packets
TRANSBYTES= 0;       % Sum of the Bytes of transmitted packets
DELAYS= 0;           % Sum of the delays of transmitted packets
MAXDELAY= 0;         % Maximum delay among all transmitted packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
EventList = [ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];

for i = 1:n
    tmp = unifrnd(0, 0.02);              % packet arrivals is unif distrib between 0 ms and 20 ms % FIRST PACKETS IS 0 TO 20 ms !!  % SEE FOOTNOTE3 
    EventList = [EventList; ARRIVAL, tmp, randi([110, 130]), tmp, VOIP];
end

%Similation loop:
while TRANSPACKETS<P                        % Stopping criterium
    EventList= sortrows(EventList,2);       % Order EventList by time
    Event= EventList(1,1);                  % Get first event 
    Clock= EventList(1,2);                  %    and all
    PacketSize= EventList(1,3);             %    associated
    ArrInstant= EventList(1,4);             %    parameters.
    PacketType = EventList(1, 5);
    EventList(1,:)= [];                     % Eliminate first event
    switch Event
        case ARRIVAL         % If first event is an ARRIVAL
            if PacketType == DATA
                TOTALPACKETS_DATA= TOTALPACKETS_DATA + 1;
                tmp= Clock + exprnd(1/lambda);
                EventList = [EventList; ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];
            else %is voip
                TOTALPACKETS_VOIP= TOTALPACKETS_VOIP + 1;
                tmp= Clock +unifrnd(0.016, 0.024);
                EventList = [EventList; ARRIVAL, tmp, randi([110, 130]), tmp, VOIP];
            end
            %%%%
            if STATE==0
                STATE= 1;
                EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock, PacketType];
            else
                if QUEUEOCCUPATION + PacketSize <= f
                    QUEUE= [QUEUE;PacketSize , Clock, PacketType];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                else
                    if PacketType == DATA
                        LOSTPACKETS_DATA= LOSTPACKETS_DATA + 1;
                    else
                        LOSTPACKETS_VOIP= LOSTPACKETS_VOIP + 1;
                    end
                end
            end

        case DEPARTURE          % If first event is a DEPARTURE
            TRANSBYTES= TRANSBYTES + PacketSize;
            DELAYS= DELAYS + (Clock - ArrInstant);
            if Clock - ArrInstant > MAXDELAY
                MAXDELAY= Clock - ArrInstant;
            end
            TRANSPACKETS= TRANSPACKETS + 1;

            if QUEUEOCCUPATION > 0
                EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), QUEUE(1, 3)];
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                QUEUE(1,:)= [];
            else
                STATE= 0;
            end

            %if PacketType == DATA
                
            %else

            %end
    end
end

%Performance parameters determination:
PL_data= 100*LOSTPACKETS_DATA/TOTALPACKETS_DATA;  % in percentage
PL_VoIP= 100*LOSTPACKETS_VOIP/TOTALPACKETS_VOIP;
APD= 1000*DELAYS/TRANSPACKETS;     % in milliseconds
MPD= 1000*MAXDELAY;                % in milliseconds
TT= 1e-6*TRANSBYTES*8/Clock;    % in Mbps

end

function out= GeneratePacketSize()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.19
        out= 64;
    elseif aux <= 0.19 + 0.23
        out= 110;
    elseif aux <= 0.19 + 0.23 + 0.17
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end