// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionRegistry {
    struct Transaction {
        string transactionType;
        uint256 amount;
        string account;
        string category;
        string tag;
        string ipfsHash;
    }

    mapping(uint256 => Transaction) public transactions;
    uint256 public transactionCount;

    function registerTransaction(string memory _type, uint256 _amount, string memory _account, string memory _category, string memory _tag, string memory _ipfsHash) public {
        transactions[transactionCount] = Transaction(_type, _amount, _account, _category, _tag, _ipfsHash);
        transactionCount++;
    }

    function getTransaction(uint256 _id) public view returns (Transaction memory) {
        return transactions[_id];
    }
}