4.  Create new files and give it a free name ending in .sol. and give it a free name ending in .sol, here I use redbelly.sol
![image](https://raw.githubusercontent.com/sychonix/chain/main/remix/photo1704046257.jpeg)

paste the code below and paste it in remix
Change ***contract GoerliJP is ERC20 {
    constructor(address owner) ERC20("MYTOKEN", "=MTKN", 1000000*10**18) {}*** with your token name
### redbelly.sol
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint totalTokens;
    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string private _name;
    string private _symbol;

    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function decimals() external pure override returns (uint) {
        return 18;
    }

    function totalSupply() external view override returns (uint) {
        return totalTokens;
    }

    modifier enoughTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "Not enough tokens!");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner!");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint initialSupply) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, msg.sender);
    }

    function balanceOf(address account) public view override returns (uint) {
        return balances[account];
    }

    function transfer(address to, uint amount) external override enoughTokens(msg.sender, amount) {
        _beforeTokenTransfer(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function mint(uint amount, address mint_to) public onlyOwner {
        _beforeTokenTransfer(address(0), mint_to, amount);
        balances[mint_to] += amount;
        totalTokens += amount;
        emit Transfer(address(0), mint_to, amount);
    }

    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        totalTokens -= amount;
    }

    function allowance(address _owner, address spender) public view override returns (uint) {
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) public override {
        _approve(msg.sender, spender, amount);
    }

    function _approve(address sender, address spender, uint amount) internal virtual {
        allowances[sender][spender] = amount;
        emit Approval(sender, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) public override enoughTokens(sender, amount) {
        _beforeTokenTransfer(sender, recipient, amount);
        require(allowances[sender][msg.sender] >= amount, "Check allowance!");
        allowances[sender][msg.sender] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual {}
}

contract GoerliJP is ERC20 {
    constructor(address owner) ERC20("MYTOKEN", "=MTKN", 1000000*10**18) {}

    // Fungsi untuk mentransfer token ke beberapa alamat sekaligus
    function transferBatch(address[] calldata recipients, uint[] calldata amounts) external {
        require(recipients.length == amounts.length, "Invalid input length");

        uint totalAmount = 0;
        for (uint256 i = 0; i < recipients.length; i++) {
            totalAmount += amounts[i];
        }

        require(balanceOf(msg.sender) >= totalAmount, "Not enough tokens to transfer");

        for (uint256 i = 0; i < recipients.length; i++) {
            address to = recipients[i];
            uint256 amount = amounts[i];
            _beforeTokenTransfer(msg.sender, to, amount);

            balances[msg.sender] -= amount;
            balances[to] += amount;
            emit Transfer(msg.sender, to, amount);
        }
    }
}
```
### IERC20.SOL
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint);
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address to, uint amount) external;
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external;
    function transferFrom(address sender, address recipient, uint amount) external;
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}
```

### ERC721
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/nibbstack/erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/nibbstack/erc721/src/contracts/ownership/ownable.sol";

/**
 * @dev This is an example contract implementation of NFToken with metadata extension.
 */
contract MyArtSale is
  NFTokenMetadata,
  Ownable
{

  /**
   * @dev Contract constructor. Sets metadata extension `name` and `symbol`.
   */
  constructor()
  {
    nftName = "SYXHONIX";
    nftSymbol = "SYNX";
  }

  /**
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   * @param _tokenId of the NFT to be minted by the msg.sender.
   * @param _uri String representing RFC 3986 URI.
   */
  function mint(
    address _to,
    uint256 _tokenId,
    string calldata _uri
  )
    external
    onlyOwner
  {
    super._mint(_to, _tokenId);
    super._setTokenUri(_tokenId, _uri);
  }

}
```


### Remix
```
pragma solidity 0.8.17;

// SPDX-License-Identifier: MIT

contract JEZFinance {
  string public name = "SYCHONIX";
  string public symbol = "SYNX";
  uint8 public decimals = 18;
  uint256 public totalSupply = 10000000000;

  mapping (address => uint256) public balances;
  address public owner;

  constructor() {
    owner = msg.sender;
    balances[owner] = totalSupply;
  }

  function transfer(address recipient, uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance.");
    balances[msg.sender] -= amount;
    balances[recipient] += amount;
  }
}
```
