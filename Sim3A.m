function [PL_data, PL_VoIP , APDd, APDv, MPDd, MPDv , TT] = Sim3A(lambda,C,f,P, n, b)
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

TRANSPACKETS_DATA = 0; % No. of transmitted data packets
TRANSPACKETS_VOIP = 0; % No. of transmitted voip packets
TRANSBYTES_DATA = 0;   % Sum of the Bytes of transmitted data packets
TRANSBYTES_VOIP = 0;   % Sum of the Bytes of transmitted voip packets
DELAYS_DATA = 0;             % Sum of the delays of transmitted data packets
DELAYS_VOIP = 0;             % Sum of the delays of transmitted voip packets
MAXDELAY_DATA = 0;           % Maximum delay among all transmitted data packets
MAXDELAY_VOIP = 0;

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
while TRANSPACKETS_DATA + TRANSPACKETS_VOIP<P                        % Stopping criterium
    
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
            if (rand() < (1-b)^(PacketSize*8))
                if (PacketType == DATA) % Data 
                    TRANSBYTES_DATA= TRANSBYTES_DATA + PacketSize;
                    DELAYS_DATA = DELAYS_DATA + (Clock - ArrInstant);
                    if Clock - ArrInstant > MAXDELAY_DATA
                        MAXDELAY_DATA= Clock - ArrInstant;
                    end
                    TRANSPACKETS_DATA= TRANSPACKETS_DATA + 1;
                else % VoIP
                    TRANSBYTES_VOIP= TRANSBYTES_VOIP + PacketSize;
                    DELAYS_VOIP= DELAYS_VOIP + (Clock - ArrInstant);
                    if Clock - ArrInstant > MAXDELAY_VOIP
                        MAXDELAY_VOIP= Clock - ArrInstant;
                    end
                    TRANSPACKETS_VOIP= TRANSPACKETS_VOIP + 1;
                end
            else
                 if (PacketType == DATA)         % Data Packet
                    LOSTPACKETS_DATA = LOSTPACKETS_DATA + 1;
                else                            % VoIP Packet
                    LOSTPACKETS_VOIP = LOSTPACKETS_VOIP + 1;
                end
            end


            if QUEUEOCCUPATION > 0
                EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), QUEUE(1, 3)];
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                QUEUE(1,:)= [];
            else
                STATE= 0;
            end
    end
end

%Performance parameters determination:
PL_data= 100*LOSTPACKETS_DATA/TOTALPACKETS_DATA;  % in percentage
PL_VoIP= 100*LOSTPACKETS_VOIP/TOTALPACKETS_VOIP;

APDd = 1000*DELAYS_DATA/TRANSPACKETS_DATA;                     % in milliseconds
APDv = 1000*DELAYS_VOIP/TRANSPACKETS_VOIP;                     % in milliseconds
MPDd = 1000*MAXDELAY_DATA;                                       % in milliseconds
MPDv = 1000*MAXDELAY_VOIP;                                       % in milliseconds
TT = 1e-6*(TRANSBYTES_DATA+TRANSBYTES_VOIP)*8/Clock;  % in Mbps

%APD= 1000*DELAYS/TRANSPACKETS;     % in milliseconds
%MPD= 1000*MAXDELAY;                % in milliseconds
%TT= 1e-6*TRANSBYTES*8/Clock;    % in Mbps

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