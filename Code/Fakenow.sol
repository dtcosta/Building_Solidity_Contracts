pragma solidity ^0.5.0;
// lvl 3: equity plan
contract DeferredEquityPlan {
    uint fakenow = now;
    address human_resources;
    address payable employee; // bob
    bool active = true;
    uint total_shares = 1000;
    uint annual_distribution = 250; // 1000 shares over 4 years
    uint start_time = fakenow; // contract start time
    uint unlock_time = fakenow + 365 days; // will increment every year
    uint public distributed_shares; // starts at 0
    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }
    
    function fastforward() public {
    fakenow += 100 days;
}

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        require(unlock_time <= fakenow, "Shares have not vested yet!");
        require(distributed_shares < total_shares, "All shares have been distributed.");
        unlock_time += 365 days; // lock for another year
        distributed_shares = (fakenow - start_time) / 365 days * annual_distribution; // calculate total shares from how many years have passed * annual_distribution
        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }
    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }
    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}