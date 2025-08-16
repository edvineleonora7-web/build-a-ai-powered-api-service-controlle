pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/oraclize/ethereum-api/blob/master/contracts/APIService.sol";

contract AIpoweredAPIController is Ownable, APIService {
    address private oracleAddress;
    bytes32 private jobId;
    uint256 private fee;

    mapping (address => bool) public authorizedUsers;

    event NewAPIRequest(address indexed user, string query);
    event NewAPIResponse(address indexed user, string response);

    constructor() public {
        oracleAddress = 0x6f485C558Ca94609106879265Be805b679D09a76;
        jobId = "myJobId";
        fee = 0.01 ether;
    }

    function setAuthorizedUser(address user) public onlyOwner {
        authorizedUsers[user] = true;
    }

    function makeAPIRequest(string memory query) public {
        require(authorizedUsers[msg.sender], "Only authorized users can make API requests");
        NewAPIRequest(msg.sender, query);
        APIService.query(oracleAddress, jobId, query, fee);
    }

    function __callback(bytes32 _jobId, string memory _result) public {
        require(msg.sender == oracleAddress, "Only the oracle can call this function");
        NewAPIResponse(msg.sender, _result);
    }
}