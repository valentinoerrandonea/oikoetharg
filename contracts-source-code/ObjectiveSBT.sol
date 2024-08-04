// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ObjectiveSBT is ERC721URIStorage {
    uint256 public tokenCounter;
    address public owner;

    struct Objective {
        string name;
        string timeline;
        string movimiento;
        string categoria;
        string tipo;
        uint256 amount;
        string status;
    }

    mapping(address => Objective[]) public objectives;
    string public baseTokenURI;

    constructor() ERC721("ObjectiveSBT", "OSBT") {
        tokenCounter = 0;
        owner = msg.sender;
        baseTokenURI = "https://ih1.redbubble.net/image.663983836.0089/st,small,507x507-pad,600x600,f8f8f8.u17.jpg";
    }

    function addObjective(
        address _user,
        string memory _name,
        string memory _timeline,
        string memory _movimiento,
        string memory _categoria,
        string memory _tipo,
        uint256 _amount,
        string memory _status
    ) public {
        require(msg.sender == owner, "Only owner can add objectives");
        objectives[_user].push(Objective(_name, _timeline, _movimiento, _categoria, _tipo, _amount, _status));
    }

    function completeObjective(address _user, uint256 _objectiveIndex) public {
        require(msg.sender == owner, "Only owner can complete objectives");
        require(_objectiveIndex < objectives[_user].length, "Invalid objective index");
        Objective storage objective = objectives[_user][_objectiveIndex];
        require(keccak256(bytes(objective.status)) != keccak256(bytes("completed")), "Objective already completed");

        objective.status = "completed";
        mintSBT(_user);
    }

    function mintSBT(address _user) internal {
        uint256 newTokenId = tokenCounter;
        _safeMint(_user, newTokenId);
        _setTokenURI(newTokenId, baseTokenURI);
        tokenCounter += 1;
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}