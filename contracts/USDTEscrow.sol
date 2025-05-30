// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title USDTEscrow
 * @dev A 2-of-3 multisig escrow contract for USDT trading
 */
contract USDTEscrow is ReentrancyGuard {
    IERC20 public usdt;
    
    address public buyer;
    address public seller;
    address public platform;
    
    uint256 public amount;
    uint256 public releaseTime;
    bool public isReleased;
    bool public isRefunded;
    
    mapping(address => bool) public hasApproved;
    uint8 public approvalsCount;
    
    event EscrowFunded(address indexed buyer, uint256 amount);
    event EscrowReleased(address indexed seller, uint256 amount);
    event EscrowRefunded(address indexed buyer, uint256 amount);
    event ApprovalReceived(address indexed approver);
    
    modifier onlyParticipant() {
        require(
            msg.sender == buyer || msg.sender == seller || msg.sender == platform,
            "Only participants can call this function"
        );
        _;
    }
    
    constructor(
        address _usdt,
        address _buyer,
        address _seller,
        address _platform,
        uint256 _amount,
        uint256 _lockTime
    ) {
        usdt = IERC20(_usdt);
        buyer = _buyer;
        seller = _seller;
        platform = _platform;
        amount = _amount;
        releaseTime = block.timestamp + _lockTime;
    }
    
    function fund() external nonReentrant {
        require(msg.sender == buyer, "Only buyer can fund");
        require(!isReleased && !isRefunded, "Escrow already completed");
        
        require(
            usdt.transferFrom(buyer, address(this), amount),
            "USDT transfer failed"
        );
        
        emit EscrowFunded(buyer, amount);
    }
    
    function approve() external onlyParticipant {
        require(!hasApproved[msg.sender], "Already approved");
        require(!isReleased && !isRefunded, "Escrow already completed");
        
        hasApproved[msg.sender] = true;
        approvalsCount++;
        
        emit ApprovalReceived(msg.sender);
    }
    
    function release() external onlyParticipant {
        require(!isReleased && !isRefunded, "Escrow already completed");
        require(approvalsCount >= 2, "Insufficient approvals");
        
        isReleased = true;
        require(
            usdt.transfer(seller, amount),
            "USDT transfer failed"
        );
        
        emit EscrowReleased(seller, amount);
    }
    
    function refund() external onlyParticipant {
        require(!isReleased && !isRefunded, "Escrow already completed");
        require(
            block.timestamp > releaseTime || approvalsCount >= 2,
            "Cannot refund yet"
        );
        
        isRefunded = true;
        require(
            usdt.transfer(buyer, amount),
            "USDT transfer failed"
        );
        
        emit EscrowRefunded(buyer, amount);
    }
    
    function getStatus() external view returns (
        bool _isReleased,
        bool _isRefunded,
        uint8 _approvalsCount,
        uint256 _releaseTime,
        uint256 _amount
    ) {
        return (
            isReleased,
            isRefunded,
            approvalsCount,
            releaseTime,
            amount
        );
    }
} 