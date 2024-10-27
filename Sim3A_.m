function [PLdata, PLVoIP, APDdata, APDVoIP, MPDdata, MPDVoIP, TTdata] = Sim3A_(lambda,C,f,P,n,b)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
%  n      - number of VoIP flows
%  b      - Bit Error Rate
% OUTPUT PARAMETERS:
%  PL   - packet loss (%)
%  APD  - average packet delay (milliseconds)
%  MPD  - maximum packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet
ARRIVALVoIP= 2;       % Arrival of a VoIP            
DEPARTUREVoIP= 3;     % Departure of a VoIP

%State variables:
STATE = 0;          % 0 - connection is free; 1 - connection is occupied
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS= 0;     % No. of data packets arrived to the system
LOSTPACKETS= 0;      % No. of data packets dropped due to buffer overflow
TRANSPACKETS= 0;     % No. of transmitted data packets
TRANSBYTES= 0;       % Sum of the Bytes of transmitted data and VoIP packets
DELAYS= 0;           % Sum of the delays of transmitted data packets
MAXDELAY= 0;         % Maximum delay among all transmitted data packets
%VoIP Statistical Counters
TOTALVoIPPACKETS= 0;     % No. of VoIP packets arrived to the system
LOSTVoIPPACKETS= 0;      % No. of VoIP packets dropped due to buffer overflow
TRANSVoIPPACKETS= 0;     % No. of transmitted VoIP packets
DELAYSVoIP= 0;           % Sum of the delays of transmitted VoIP packets
MAXDELAYVoIP= 0;         % Maximum delay among all transmitted VoIP packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
EventList = [ARRIVAL, tmp, GeneratePacketSize(), tmp];

for i=1:n   % VoIP n flows first arrivals
    % First void interval
    tmp= Clock + unifrnd(0,20e-3);
    EventList = [EventList; ARRIVALVoIP, tmp, GenerateVoIPPacketSize(), tmp];
end

%Simulation loop:
while TRANSPACKETS+TRANSVoIPPACKETS<P               % Stopping criterium
    EventList= sortrows(EventList,2);  % Order EventList by time
    Event= EventList(1,1);              % Get first event 
    Clock= EventList(1,2);              %    and all
    PacketSize= EventList(1,3);        %    associated
    ArrInstant= EventList(1,4);    %    parameters.
    EventList(1,:)= [];                 % Eliminate first event
    switch Event
        case ARRIVAL         % If first event is an ARRIVAL of data packet
            TOTALPACKETS= TOTALPACKETS+1;
            tmp= Clock + exprnd(1/lambda);
            EventList = [EventList; ARRIVAL, tmp, GeneratePacketSize(), tmp];
            if STATE==0
                STATE= 1;
                EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock];
            else
                if QUEUEOCCUPATION + PacketSize <= f
                    QUEUE= [QUEUE;PacketSize , Clock, ARRIVAL];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                else       % Data packet is lost if the queue is full
                    LOSTPACKETS= LOSTPACKETS + 1;
                end
            end
        case ARRIVALVoIP        % If first event is an ARRIVAL of VoIP packet
            TOTALVoIPPACKETS= TOTALVoIPPACKETS+1;
            tmp= Clock + unifrnd(16e-3,24e-3);    % Arrivals ~ U(16,24) ms
            EventList = [EventList; ARRIVALVoIP, tmp, GenerateVoIPPacketSize(), tmp];
            if STATE==0
                STATE= 1;
                EventList = [EventList; DEPARTUREVoIP, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock];
            else
                if QUEUEOCCUPATION + PacketSize <= f
                    QUEUE= [QUEUE;PacketSize , Clock, ARRIVALVoIP];
                    QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                else
                    LOSTVoIPPACKETS= LOSTVoIPPACKETS + 1;
                end
            end
        case DEPARTURE          % If first event is a DEPARTURE of data packet
            P_no_bit_errors = (1 - b)^(PacketSize * 8); % bits are random binomial variables
            if rand < P_no_bit_errors            % Check if the packet has no errors
                TRANSBYTES= TRANSBYTES + PacketSize;
                DELAYS= DELAYS + (Clock - ArrInstant);
                if Clock - ArrInstant > MAXDELAY
                    MAXDELAY= Clock - ArrInstant;
                end
                TRANSPACKETS= TRANSPACKETS + 1;
            else
                LOSTPACKETS = LOSTPACKETS +1;
            end
            if QUEUEOCCUPATION > 0
                if QUEUE(1,3) == ARRIVAL    % Check if the packet is data on the queue
                    EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                elseif QUEUE(1,3) == ARRIVALVoIP    % Check if the packet is VoIP on the queue
                    EventList = [EventList; DEPARTUREVoIP, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                end
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                QUEUE(1,:)= [];
            else
                STATE= 0;
            end
        case DEPARTUREVoIP      % If first event is a DEPARTURE of VoIP packet
            P_no_bit_errors = (1 - b)^(PacketSize * 8); % bits are random binomial variables
            if rand < P_no_bit_errors            % Check if the packet has no errors
                TRANSBYTES= TRANSBYTES + PacketSize;
                DELAYSVoIP= DELAYSVoIP + (Clock - ArrInstant);
                if Clock - ArrInstant > MAXDELAYVoIP
                    MAXDELAYVoIP= Clock - ArrInstant;
                end
                TRANSVoIPPACKETS= TRANSVoIPPACKETS + 1;
            else
                LOSTPACKETS = LOSTPACKETS +1;
            end
            if QUEUEOCCUPATION > 0
                if QUEUE(1,3) == ARRIVAL    % Check if the packet is data on the queue
                    EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                elseif QUEUE(1,3) == ARRIVALVoIP    % Check if the packet is VoIP on the queue
                    EventList = [EventList; DEPARTUREVoIP, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2)];
                end
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                QUEUE(1,:)= [];
            else
                STATE= 0;
            end
    end
end

%Performance parameters determination:
PLdata= 100*LOSTPACKETS/TOTALPACKETS;  % in percentage
APDdata= 1000*DELAYS/TRANSPACKETS;     % in milliseconds
MPDdata= 1000*MAXDELAY;                % in milliseconds
%VoIP Performance parameters determination:
PLVoIP= 100*LOSTVoIPPACKETS/TOTALVoIPPACKETS;  % in percentage
APDVoIP= 1000*DELAYSVoIP/TRANSVoIPPACKETS;     % in milliseconds
MPDVoIP= 1000*MAXDELAYVoIP;                % in milliseconds
% TT considers data an VoIP packets
TTdata= 1e-6*TRANSBYTES*8/Clock;    % in Mbps

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

function out= GenerateVoIPPacketSize()
    out = randi([110, 130]);
end
