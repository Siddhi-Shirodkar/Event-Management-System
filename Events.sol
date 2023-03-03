// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract EventContract{

    struct Event{
        address organiser;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketRemaining;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date, uint price, uint ticketcount,uint ticketRemaining) external{
        require(date>block.timestamp,"Can organize event for future date");
        require(ticketcount>0,"You can organize event only if you create more than 0 tickets");

        events[nextId] = Event(msg.sender,name,date,price,ticketcount,ticketRemaining);
        nextId++;
    }
    function purchaseTicket(uint id, uint quantity) external payable{
        require(events[id].date!=0,"This Event will not exist");
        require(events[id].date>block.timestamp);
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity));
        require(_event.ticketRemaining>=quantity,"Not enough tickets");
        _event.ticketRemaining-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transfertheTicket(uint id, uint quantity, address to) external {
        require(events[id].date!=0);
        require(events[id].date>block.timestamp);
        require(tickets[msg.sender][id]>=quantity,"You should have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}