pragma solidity ^0.5.0;

// lvl 3: equity plan
contract DeferredEquityPlan {
    uint fakenow = now;
    function fastforward() public {
        fakenow += 100 days;
    }

    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    uint total_shares = 1000; // Set the total shares and annual distribution
    uint annual_distribution = 250; // total shares divided by annual distribution = 250 shares per year (with a four year vesting period)

    uint start_time = now; // permanently store the time this contract was initialized

    uint unlock_time = now + 365 days; // Set the `unlock_time` to be 365 days from now
    
    uint public distributed_shares; // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        // "require" statements to enforce that:
        require(unlock_time <= now, "Contract requires a lock period of 365 days"); // 1: `unlock_time` is less than or equal to `now`
        require(distributed_shares < total_shares); // 2: `distributed_shares` is less than the `total_shares`
        // Add 365 days to the `unlock_time`
        unlock_time + 365 days;
        // Calculate the shares distributed by using the function (now - start_time) / 365 days * the annual distribution
        distributed_shares = (now - start_time) / 365 days * annual_distribution;
        if (distributed_shares > 1000) { // double check in case the employee does not cash out until after 5+ years
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
