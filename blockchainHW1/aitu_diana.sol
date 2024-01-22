// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/e5c63635e3508a8d9d0afed091578cc4bb59a9c7/contracts/token/ERC20/ERC20.sol';
import 'https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/1dc26f977c57a6ba3ed6d7c53cafdb191e7e59ae/contracts/BokkyPooBahsDateTimeLibrary.sol';

contract aitu_diana is ERC20 {
    address public admin;
    uint public totalTransactions;
    using BokkyPooBahsDateTimeLibrary for uint256;

    struct TransactionInfo {
        address sender;
        address recipient;
        uint amount;
        uint timestamp;
    }

    mapping(uint => TransactionInfo) public transactions;

    constructor() ERC20('MyToken', 'MTN') {
        _mint(msg.sender, 2000);
        admin = msg.sender;
        totalTransactions = 0;
    }

    function mint(address to, uint amount) external {
        require(msg.sender == admin, 'only admin');
        _mint(to, amount);
        _addTransaction(msg.sender, to, amount);
    }

    function burn(uint amount) external {
        _burn(msg.sender, amount);
        _addTransaction(msg.sender, address(0), amount);
    }

    function _addTransaction(address sender, address recipient, uint amount) internal {
        transactions[totalTransactions] = TransactionInfo({
            sender: sender,
            recipient: recipient,
            amount: amount,
            timestamp: block.timestamp
        });
        totalTransactions++;
    }

    function getTransactionInfo(uint transactionId) external view returns (
        address sender,
        address recipient,
        uint amount,
        uint timestamp
    ) {
        require(transactionId < totalTransactions, 'Invalid transaction ID');
        TransactionInfo memory transaction = transactions[transactionId];
        return (transaction.sender, transaction.recipient, transaction.amount, transaction.timestamp);
    }

    function getLatestTransactionTimestamp() public view returns (
        uint year, uint month, uint day, uint hour, uint minute, uint second
    ) {
        uint256 timestamp = block.timestamp;
        (year, month, day, hour, minute, second) = timestamp.timestampToDateTime();
        return (year, month, day, hour, minute, second);
    }

    function getTransactionSender() public view returns (address) {
        return msg.sender;
    }

    function getTransactionReceiver(uint transactionId) public view returns (address) {
        require(transactionId < totalTransactions, 'Invalid transaction ID');
        return transactions[transactionId].recipient;
    }
}
