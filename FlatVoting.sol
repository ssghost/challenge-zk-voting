// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/utils/Context.sol@v5.0.2

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v5.0.2

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @zk-kit/lean-imt.sol/Constants.sol@v2.0.1

// Original license: SPDX_License_Identifier: UNLICENSED
pragma solidity ^0.8.4;

uint256 constant SNARK_SCALAR_FIELD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;


// File poseidon-solidity/PoseidonT3.sol@v0.0.5

/// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

library PoseidonT3 {
  uint constant M00 = 0x109b7f411ba0e4c9b2b70caf5c36a7b194be7c11ad24378bfedb68592ba8118b;
  uint constant M01 = 0x2969f27eed31a480b9c36c764379dbca2cc8fdd1415c3dded62940bcde0bd771;
  uint constant M02 = 0x143021ec686a3f330d5f9e654638065ce6cd79e28c5b3753326244ee65a1b1a7;
  uint constant M10 = 0x16ed41e13bb9c0c66ae119424fddbcbc9314dc9fdbdeea55d6c64543dc4903e0;
  uint constant M11 = 0x2e2419f9ec02ec394c9871c832963dc1b89d743c8c7b964029b2311687b1fe23;
  uint constant M12 = 0x176cc029695ad02582a70eff08a6fd99d057e12e58e7d7b6b16cdfabc8ee2911;

  // See here for a simplified implementation: https://github.com/vimwitch/poseidon-solidity/blob/e57becdabb65d99fdc586fe1e1e09e7108202d53/contracts/Poseidon.sol#L40
  // Inspired by: https://github.com/iden3/circomlibjs/blob/v0.0.8/src/poseidon_slow.js
  function hash(uint[2] memory) public pure returns (uint) {
    assembly {
      let F := 21888242871839275222246405745257275088548364400416034343698204186575808495617
      let M20 := 0x2b90bba00fca0589f617e7dcbfe82e0df706ab640ceb247b791a93b74e36736d
      let M21 := 0x101071f0032379b697315876690f053d148d4e109f5fb065c8aacc55a0f89bfa
      let M22 := 0x19a3fc0a56702bf417ba7fee3802593fa644470307043f7773279cd71d25d5e0

      // load the inputs from memory
      let state1 := add(mod(mload(0x80), F), 0x00f1445235f2148c5986587169fc1bcd887b08d4d00868df5696fff40956e864)
      let state2 := add(mod(mload(0xa0), F), 0x08dff3487e8ac99e1f29a058d0fa80b930c728730b7ab36ce879f3890ecf73f5)
      let scratch0 := mulmod(state1, state1, F)
      state1 := mulmod(mulmod(scratch0, scratch0, F), state1, F)
      scratch0 := mulmod(state2, state2, F)
      state2 := mulmod(mulmod(scratch0, scratch0, F), state2, F)
      scratch0 := add(
        0x2f27be690fdaee46c3ce28f7532b13c856c35342c84bda6e20966310fadc01d0,
        add(add(15452833169820924772166449970675545095234312153403844297388521437673434406763, mulmod(state1, M10, F)), mulmod(state2, M20, F))
      )
      let scratch1 := add(
        0x2b2ae1acf68b7b8d2416bebf3d4f6234b763fe04b8043ee48b8327bebca16cf2,
        add(add(18674271267752038776579386132900109523609358935013267566297499497165104279117, mulmod(state1, M11, F)), mulmod(state2, M21, F))
      )
      let scratch2 := add(
        0x0319d062072bef7ecca5eac06f97d4d55952c175ab6b03eae64b44c7dbf11cfa,
        add(add(14817777843080276494683266178512808687156649753153012854386334860566696099579, mulmod(state1, M12, F)), mulmod(state2, M22, F))
      )
      let state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := mulmod(scratch1, scratch1, F)
      scratch1 := mulmod(mulmod(state0, state0, F), scratch1, F)
      state0 := mulmod(scratch2, scratch2, F)
      scratch2 := mulmod(mulmod(state0, state0, F), scratch2, F)
      state0 := add(0x28813dcaebaeaa828a376df87af4a63bc8b7bf27ad49c6298ef7b387bf28526d, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x2727673b2ccbc903f181bf38e1c1d40d2033865200c352bc150928adddf9cb78, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x234ec45ca27727c2e74abd2b2a1494cd6efbd43e340587d6b8fb9e31e65cc632, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := mulmod(state1, state1, F)
      state1 := mulmod(mulmod(scratch0, scratch0, F), state1, F)
      scratch0 := mulmod(state2, state2, F)
      state2 := mulmod(mulmod(scratch0, scratch0, F), state2, F)
      scratch0 := add(0x15b52534031ae18f7f862cb2cf7cf760ab10a8150a337b1ccd99ff6e8797d428, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x0dc8fad6d9e4b35f5ed9a3d186b79ce38e0e8a8d1b58b132d701d4eecf68d1f6, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x1bcd95ffc211fbca600f705fad3fb567ea4eb378f62e1fec97805518a47e4d9c, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := mulmod(scratch1, scratch1, F)
      scratch1 := mulmod(mulmod(state0, state0, F), scratch1, F)
      state0 := mulmod(scratch2, scratch2, F)
      scratch2 := mulmod(mulmod(state0, state0, F), scratch2, F)
      state0 := add(0x10520b0ab721cadfe9eff81b016fc34dc76da36c2578937817cb978d069de559, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x1f6d48149b8e7f7d9b257d8ed5fbbaf42932498075fed0ace88a9eb81f5627f6, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x1d9655f652309014d29e00ef35a2089bfff8dc1c816f0dc9ca34bdb5460c8705, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x04df5a56ff95bcafb051f7b1cd43a99ba731ff67e47032058fe3d4185697cc7d, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x0672d995f8fff640151b3d290cedaf148690a10a8c8424a7f6ec282b6e4be828, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x099952b414884454b21200d7ffafdd5f0c9a9dcc06f2708e9fc1d8209b5c75b9, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x052cba2255dfd00c7c483143ba8d469448e43586a9b4cd9183fd0e843a6b9fa6, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x0b8badee690adb8eb0bd74712b7999af82de55707251ad7716077cb93c464ddc, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x119b1590f13307af5a1ee651020c07c749c15d60683a8050b963d0a8e4b2bdd1, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x03150b7cd6d5d17b2529d36be0f67b832c4acfc884ef4ee5ce15be0bfb4a8d09, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x2cc6182c5e14546e3cf1951f173912355374efb83d80898abe69cb317c9ea565, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x005032551e6378c450cfe129a404b3764218cadedac14e2b92d2cd73111bf0f9, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x233237e3289baa34bb147e972ebcb9516469c399fcc069fb88f9da2cc28276b5, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x05c8f4f4ebd4a6e3c980d31674bfbe6323037f21b34ae5a4e80c2d4c24d60280, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x0a7b1db13042d396ba05d818a319f25252bcf35ef3aeed91ee1f09b2590fc65b, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x2a73b71f9b210cf5b14296572c9d32dbf156e2b086ff47dc5df542365a404ec0, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1ac9b0417abcc9a1935107e9ffc91dc3ec18f2c4dbe7f22976a760bb5c50c460, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x12c0339ae08374823fabb076707ef479269f3e4d6cb104349015ee046dc93fc0, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x0b7475b102a165ad7f5b18db4e1e704f52900aa3253baac68246682e56e9a28e, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x037c2849e191ca3edb1c5e49f6e8b8917c843e379366f2ea32ab3aa88d7f8448, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x05a6811f8556f014e92674661e217e9bd5206c5c93a07dc145fdb176a716346f, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x29a795e7d98028946e947b75d54e9f044076e87a7b2883b47b675ef5f38bd66e, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x20439a0c84b322eb45a3857afc18f5826e8c7382c8a1585c507be199981fd22f, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x2e0ba8d94d9ecf4a94ec2050c7371ff1bb50f27799a84b6d4a2a6f2a0982c887, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x143fd115ce08fb27ca38eb7cce822b4517822cd2109048d2e6d0ddcca17d71c8, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x0c64cbecb1c734b857968dbbdcf813cdf8611659323dbcbfc84323623be9caf1, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x028a305847c683f646fca925c163ff5ae74f348d62c2b670f1426cef9403da53, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x2e4ef510ff0b6fda5fa940ab4c4380f26a6bcb64d89427b824d6755b5db9e30c, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x0081c95bc43384e663d79270c956ce3b8925b4f6d033b078b96384f50579400e, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x2ed5f0c91cbd9749187e2fade687e05ee2491b349c039a0bba8a9f4023a0bb38, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x30509991f88da3504bbf374ed5aae2f03448a22c76234c8c990f01f33a735206, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x1c3f20fd55409a53221b7c4d49a356b9f0a1119fb2067b41a7529094424ec6ad, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x10b4e7f3ab5df003049514459b6e18eec46bb2213e8e131e170887b47ddcb96c, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x2a1982979c3ff7f43ddd543d891c2abddd80f804c077d775039aa3502e43adef, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1c74ee64f15e1db6feddbead56d6d55dba431ebc396c9af95cad0f1315bd5c91, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x07533ec850ba7f98eab9303cace01b4b9e4f2e8b82708cfa9c2fe45a0ae146a0, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x21576b438e500449a151e4eeaf17b154285c68f42d42c1808a11abf3764c0750, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x2f17c0559b8fe79608ad5ca193d62f10bce8384c815f0906743d6930836d4a9e, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x2d477e3862d07708a79e8aae946170bc9775a4201318474ae665b0b1b7e2730e, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x162f5243967064c390e095577984f291afba2266c38f5abcd89be0f5b2747eab, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x2b4cb233ede9ba48264ecd2c8ae50d1ad7a8596a87f29f8a7777a70092393311, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x2c8fbcb2dd8573dc1dbaf8f4622854776db2eece6d85c4cf4254e7c35e03b07a, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x1d6f347725e4816af2ff453f0cd56b199e1b61e9f601e9ade5e88db870949da9, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x204b0c397f4ebe71ebc2d8b3df5b913df9e6ac02b68d31324cd49af5c4565529, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x0c4cb9dc3c4fd8174f1149b3c63c3c2f9ecb827cd7dc25534ff8fb75bc79c502, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x174ad61a1448c899a25416474f4930301e5c49475279e0639a616ddc45bc7b54, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1a96177bcf4d8d89f759df4ec2f3cde2eaaa28c177cc0fa13a9816d49a38d2ef, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x066d04b24331d71cd0ef8054bc60c4ff05202c126a233c1a8242ace360b8a30a, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x2a4c4fc6ec0b0cf52195782871c6dd3b381cc65f72e02ad527037a62aa1bd804, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x13ab2d136ccf37d447e9f2e14a7cedc95e727f8446f6d9d7e55afc01219fd649, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x1121552fca26061619d24d843dc82769c1b04fcec26f55194c2e3e869acc6a9a, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x00ef653322b13d6c889bc81715c37d77a6cd267d595c4a8909a5546c7c97cff1, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x0e25483e45a665208b261d8ba74051e6400c776d652595d9845aca35d8a397d3, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x29f536dcb9dd7682245264659e15d88e395ac3d4dde92d8c46448db979eeba89, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x2a56ef9f2c53febadfda33575dbdbd885a124e2780bbea170e456baace0fa5be, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x1c8361c78eb5cf5decfb7a2d17b5c409f2ae2999a46762e8ee416240a8cb9af1, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x151aff5f38b20a0fc0473089aaf0206b83e8e68a764507bfd3d0ab4be74319c5, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x04c6187e41ed881dc1b239c88f7f9d43a9f52fc8c8b6cdd1e76e47615b51f100, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x13b37bd80f4d27fb10d84331f6fb6d534b81c61ed15776449e801b7ddc9c2967, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x01a5c536273c2d9df578bfbd32c17b7a2ce3664c2a52032c9321ceb1c4e8a8e4, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x2ab3561834ca73835ad05f5d7acb950b4a9a2c666b9726da832239065b7c3b02, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x1d4d8ec291e720db200fe6d686c0d613acaf6af4e95d3bf69f7ed516a597b646, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x041294d2cc484d228f5784fe7919fd2bb925351240a04b711514c9c80b65af1d, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x154ac98e01708c611c4fa715991f004898f57939d126e392042971dd90e81fc6, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x0b339d8acca7d4f83eedd84093aef51050b3684c88f8b0b04524563bc6ea4da4, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x0955e49e6610c94254a4f84cfbab344598f0e71eaff4a7dd81ed95b50839c82e, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x06746a6156eba54426b9e22206f15abca9a6f41e6f535c6f3525401ea0654626, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x0f18f5a0ecd1423c496f3820c549c27838e5790e2bd0a196ac917c7ff32077fb, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x04f6eeca1751f7308ac59eff5beb261e4bb563583ede7bc92a738223d6f76e13, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x2b56973364c4c4f5c1a3ec4da3cdce038811eb116fb3e45bc1768d26fc0b3758, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x123769dd49d5b054dcd76b89804b1bcb8e1392b385716a5d83feb65d437f29ef, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x2147b424fc48c80a88ee52b91169aacea989f6446471150994257b2fb01c63e9, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x0fdc1f58548b85701a6c5505ea332a29647e6f34ad4243c2ea54ad897cebe54d, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x12373a8251fea004df68abcf0f7786d4bceff28c5dbbe0c3944f685cc0a0b1f2, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x21e4f4ea5f35f85bad7ea52ff742c9e8a642756b6af44203dd8a1f35c1a90035, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x16243916d69d2ca3dfb4722224d4c462b57366492f45e90d8a81934f1bc3b147, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1efbe46dd7a578b4f66f9adbc88b4378abc21566e1a0453ca13a4159cac04ac2, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x07ea5e8537cf5dd08886020e23a7f387d468d5525be66f853b672cc96a88969a, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x05a8c4f9968b8aa3b7b478a30f9a5b63650f19a75e7ce11ca9fe16c0b76c00bc, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x20f057712cc21654fbfe59bd345e8dac3f7818c701b9c7882d9d57b72a32e83f, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x04a12ededa9dfd689672f8c67fee31636dcd8e88d01d49019bd90b33eb33db69, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x27e88d8c15f37dcee44f1e5425a51decbd136ce5091a6767e49ec9544ccd101a, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x2feed17b84285ed9b8a5c8c5e95a41f66e096619a7703223176c41ee433de4d1, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x1ed7cc76edf45c7c404241420f729cf394e5942911312a0d6972b8bd53aff2b8, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x15742e99b9bfa323157ff8c586f5660eac6783476144cdcadf2874be45466b1a, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x1aac285387f65e82c895fc6887ddf40577107454c6ec0317284f033f27d0c785, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x25851c3c845d4790f9ddadbdb6057357832e2e7a49775f71ec75a96554d67c77, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x15a5821565cc2ec2ce78457db197edf353b7ebba2c5523370ddccc3d9f146a67, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x2411d57a4813b9980efa7e31a1db5966dcf64f36044277502f15485f28c71727, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x002e6f8d6520cd4713e335b8c0b6d2e647e9a98e12f4cd2558828b5ef6cb4c9b, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x2ff7bc8f4380cde997da00b616b0fcd1af8f0e91e2fe1ed7398834609e0315d2, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x00b9831b948525595ee02724471bcd182e9521f6b7bb68f1e93be4febb0d3cbe, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x0a2f53768b8ebf6a86913b0e57c04e011ca408648a4743a87d77adbf0c9c3512, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x00248156142fd0373a479f91ff239e960f599ff7e94be69b7f2a290305e1198d, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x171d5620b87bfb1328cf8c02ab3f0c9a397196aa6a542c2350eb512a2b2bcda9, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x170a4f55536f7dc970087c7c10d6fad760c952172dd54dd99d1045e4ec34a808, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x29aba33f799fe66c2ef3134aea04336ecc37e38c1cd211ba482eca17e2dbfae1, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x1e9bc179a4fdd758fdd1bb1945088d47e70d114a03f6a0e8b5ba650369e64973, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x1dd269799b660fad58f7f4892dfb0b5afeaad869a9c4b44f9c9e1c43bdaf8f09, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x22cdbc8b70117ad1401181d02e15459e7ccd426fe869c7c95d1dd2cb0f24af38, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x0ef042e454771c533a9f57a55c503fcefd3150f52ed94a7cd5ba93b9c7dacefd, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x11609e06ad6c8fe2f287f3036037e8851318e8b08a0359a03b304ffca62e8284, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x1166d9e554616dba9e753eea427c17b7fecd58c076dfe42708b08f5b783aa9af, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x2de52989431a859593413026354413db177fbf4cd2ac0b56f855a888357ee466, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x3006eb4ffc7a85819a6da492f3a8ac1df51aee5b17b8e89d74bf01cf5f71e9ad, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x2af41fbb61ba8a80fdcf6fff9e3f6f422993fe8f0a4639f962344c8225145086, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x119e684de476155fe5a6b41a8ebc85db8718ab27889e85e781b214bace4827c3, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x1835b786e2e8925e188bea59ae363537b51248c23828f047cff784b97b3fd800, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x28201a34c594dfa34d794996c6433a20d152bac2a7905c926c40e285ab32eeb6, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x083efd7a27d1751094e80fefaf78b000864c82eb571187724a761f88c22cc4e7, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x0b6f88a3577199526158e61ceea27be811c16df7774dd8519e079564f61fd13b, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x0ec868e6d15e51d9644f66e1d6471a94589511ca00d29e1014390e6ee4254f5b, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x2af33e3f866771271ac0c9b3ed2e1142ecd3e74b939cd40d00d937ab84c98591, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x0b520211f904b5e7d09b5d961c6ace7734568c547dd6858b364ce5e47951f178, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x0b2d722d0919a1aad8db58f10062a92ea0c56ac4270e822cca228620188a1d40, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x1f790d4d7f8cf094d980ceb37c2453e957b54a9991ca38bbe0061d1ed6e562d4, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x0171eb95dfbf7d1eaea97cd385f780150885c16235a2a6a8da92ceb01e504233, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x0c2d0e3b5fd57549329bf6885da66b9b790b40defd2c8650762305381b168873, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1162fb28689c27154e5a8228b4e72b377cbcafa589e283c35d3803054407a18d, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x2f1459b65dee441b64ad386a91e8310f282c5a92a89e19921623ef8249711bc0, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x1e6ff3216b688c3d996d74367d5cd4c1bc489d46754eb712c243f70d1b53cfbb, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x01ca8be73832b8d0681487d27d157802d741a6f36cdc2a0576881f9326478875, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x1f7735706ffe9fc586f976d5bdf223dc680286080b10cea00b9b5de315f9650e, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x2522b60f4ea3307640a0c2dce041fba921ac10a3d5f096ef4745ca838285f019, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x23f0bee001b1029d5255075ddc957f833418cad4f52b6c3f8ce16c235572575b, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x2bc1ae8b8ddbb81fcaac2d44555ed5685d142633e9df905f66d9401093082d59, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x0f9406b8296564a37304507b8dba3ed162371273a07b1fc98011fcd6ad72205f, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x2360a8eb0cc7defa67b72998de90714e17e75b174a52ee4acb126c8cd995f0a8, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x15871a5cddead976804c803cbaef255eb4815a5e96df8b006dcbbc2767f88948, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x193a56766998ee9e0a8652dd2f3b1da0362f4f54f72379544f957ccdeefb420f, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x2a394a43934f86982f9be56ff4fab1703b2e63c8ad334834e4309805e777ae0f, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x1859954cfeb8695f3e8b635dcb345192892cd11223443ba7b4166e8876c0d142, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x04e1181763050e58013444dbcb99f1902b11bc25d90bbdca408d3819f4fed32b, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x0fdb253dee83869d40c335ea64de8c5bb10eb82db08b5e8b1f5e5552bfd05f23, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x058cbe8a9a5027bdaa4efb623adead6275f08686f1c08984a9d7c5bae9b4f1c0, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x1382edce9971e186497eadb1aeb1f52b23b4b83bef023ab0d15228b4cceca59a, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x03464990f045c6ee0819ca51fd11b0be7f61b8eb99f14b77e1e6634601d9e8b5, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x23f7bfc8720dc296fff33b41f98ff83c6fcab4605db2eb5aaa5bc137aeb70a58, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x0a59a158e3eec2117e6e94e7f0e9decf18c3ffd5e1531a9219636158bbaf62f2, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x06ec54c80381c052b58bf23b312ffd3ce2c4eba065420af8f4c23ed0075fd07b, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x118872dc832e0eb5476b56648e867ec8b09340f7a7bcb1b4962f0ff9ed1f9d01, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x13d69fa127d834165ad5c7cba7ad59ed52e0b0f0e42d7fea95e1906b520921b1, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x169a177f63ea681270b1c6877a73d21bde143942fb71dc55fd8a49f19f10c77b, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x04ef51591c6ead97ef42f287adce40d93abeb032b922f66ffb7e9a5a7450544d, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x256e175a1dc079390ecd7ca703fb2e3b19ec61805d4f03ced5f45ee6dd0f69ec, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x30102d28636abd5fe5f2af412ff6004f75cc360d3205dd2da002813d3e2ceeb2, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x10998e42dfcd3bbf1c0714bc73eb1bf40443a3fa99bef4a31fd31be182fcc792, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x193edd8e9fcf3d7625fa7d24b598a1d89f3362eaf4d582efecad76f879e36860, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x18168afd34f2d915d0368ce80b7b3347d1c7a561ce611425f2664d7aa51f0b5d, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x29383c01ebd3b6ab0c017656ebe658b6a328ec77bc33626e29e2e95b33ea6111, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x10646d2f2603de39a1f4ae5e7771a64a702db6e86fb76ab600bf573f9010c711, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x0beb5e07d1b27145f575f1395a55bf132f90c25b40da7b3864d0242dcb1117fb, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x16d685252078c133dc0d3ecad62b5c8830f95bb2e54b59abdffbf018d96fa336, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x0a6abd1d833938f33c74154e0404b4b40a555bbbec21ddfafd672dd62047f01a, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1a679f5d36eb7b5c8ea12a4c2dedc8feb12dffeec450317270a6f19b34cf1860, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x0980fb233bd456c23974d50e0ebfde4726a423eada4e8f6ffbc7592e3f1b93d6, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x161b42232e61b84cbf1810af93a38fc0cece3d5628c9282003ebacb5c312c72b, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x0ada10a90c7f0520950f7d47a60d5e6a493f09787f1564e5d09203db47de1a0b, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x1a730d372310ba82320345a29ac4238ed3f07a8a2b4e121bb50ddb9af407f451, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x2c8120f268ef054f817064c369dda7ea908377feaba5c4dffbda10ef58e8c556, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1c7c8824f758753fa57c00789c684217b930e95313bcb73e6e7b8649a4968f70, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x2cd9ed31f5f8691c8e39e4077a74faa0f400ad8b491eb3f7b47b27fa3fd1cf77, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x23ff4f9d46813457cf60d92f57618399a5e022ac321ca550854ae23918a22eea, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x09945a5d147a4f66ceece6405dddd9d0af5a2c5103529407dff1ea58f180426d, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x188d9c528025d4c2b67660c6b771b90f7c7da6eaa29d3f268a6dd223ec6fc630, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x3050e37996596b7f81f68311431d8734dba7d926d3633595e0c0d8ddf4f0f47f, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x15af1169396830a91600ca8102c35c426ceae5461e3f95d89d829518d30afd78, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x1da6d09885432ea9a06d9f37f873d985dae933e351466b2904284da3320d8acc, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := add(0x2796ea90d269af29f5f8acf33921124e4e4fad3dbe658945e546ee411ddaa9cb, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x202d7dd1da0f6b4b0325c8b3307742f01e15612ec8e9304a7cb0319e01d32d60, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x096d6790d05bb759156a952ba263d672a2d7f9c788f4c831a29dace4c0f8be5f, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := add(0x054efa1f65b0fce283808965275d877b438da23ce5b13e1963798cb1447d25a4, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x1b162f83d917e93edb3308c29802deb9d8aa690113b2e14864ccf6e18e4165f1, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x21e5241e12564dd6fd9f1cdd2a0de39eedfefc1466cc568ec5ceb745a0506edc, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := mulmod(scratch1, scratch1, F)
      scratch1 := mulmod(mulmod(state0, state0, F), scratch1, F)
      state0 := mulmod(scratch2, scratch2, F)
      scratch2 := mulmod(mulmod(state0, state0, F), scratch2, F)
      state0 := add(0x1cfb5662e8cf5ac9226a80ee17b36abecb73ab5f87e161927b4349e10e4bdf08, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x0f21177e302a771bbae6d8d1ecb373b62c99af346220ac0129c53f666eb24100, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x1671522374606992affb0dd7f71b12bec4236aede6290546bcef7e1f515c2320, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := mulmod(state1, state1, F)
      state1 := mulmod(mulmod(scratch0, scratch0, F), state1, F)
      scratch0 := mulmod(state2, state2, F)
      state2 := mulmod(mulmod(scratch0, scratch0, F), state2, F)
      scratch0 := add(0x0fa3ec5b9488259c2eb4cf24501bfad9be2ec9e42c5cc8ccd419d2a692cad870, add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)))
      scratch1 := add(0x193c0e04e0bd298357cb266c1506080ed36edce85c648cc085e8c57b1ab54bba, add(add(mulmod(state0, M01, F), mulmod(state1, M11, F)), mulmod(state2, M21, F)))
      scratch2 := add(0x102adf8ef74735a27e9128306dcbc3c99f6f7291cd406578ce14ea2adaba68f8, add(add(mulmod(state0, M02, F), mulmod(state1, M12, F)), mulmod(state2, M22, F)))
      state0 := mulmod(scratch0, scratch0, F)
      scratch0 := mulmod(mulmod(state0, state0, F), scratch0, F)
      state0 := mulmod(scratch1, scratch1, F)
      scratch1 := mulmod(mulmod(state0, state0, F), scratch1, F)
      state0 := mulmod(scratch2, scratch2, F)
      scratch2 := mulmod(mulmod(state0, state0, F), scratch2, F)
      state0 := add(0x0fe0af7858e49859e2a54d6f1ad945b1316aa24bfbdd23ae40a6d0cb70c3eab1, add(add(mulmod(scratch0, M00, F), mulmod(scratch1, M10, F)), mulmod(scratch2, M20, F)))
      state1 := add(0x216f6717bbc7dedb08536a2220843f4e2da5f1daa9ebdefde8a5ea7344798d22, add(add(mulmod(scratch0, M01, F), mulmod(scratch1, M11, F)), mulmod(scratch2, M21, F)))
      state2 := add(0x1da55cc900f0d21f4a3e694391918a1b3c23b2ac773c6b3ef88e2e4228325161, add(add(mulmod(scratch0, M02, F), mulmod(scratch1, M12, F)), mulmod(scratch2, M22, F)))
      scratch0 := mulmod(state0, state0, F)
      state0 := mulmod(mulmod(scratch0, scratch0, F), state0, F)
      scratch0 := mulmod(state1, state1, F)
      state1 := mulmod(mulmod(scratch0, scratch0, F), state1, F)
      scratch0 := mulmod(state2, state2, F)
      state2 := mulmod(mulmod(scratch0, scratch0, F), state2, F)

      mstore(0x0, mod(add(add(mulmod(state0, M00, F), mulmod(state1, M10, F)), mulmod(state2, M20, F)), F))

      return(0, 0x20)
    }
  }
}


// File @zk-kit/lean-imt.sol/InternalLeanIMT.sol@v2.0.1

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;


struct LeanIMTData {
    // Tracks the current number of leaves in the tree.
    uint256 size;
    // Represents the current depth of the tree, which can increase as new leaves are inserted.
    uint256 depth;
    // A mapping from each level of the tree to the node value of the last even position at that level.
    // Used for efficient inserts, updates and root calculations.
    mapping(uint256 => uint256) sideNodes;
    // A mapping from leaf values to their respective indices in the tree.
    // This facilitates checks for leaf existence and retrieval of leaf positions.
    mapping(uint256 => uint256) leaves;
}

error WrongSiblingNodes();
error LeafGreaterThanSnarkScalarField();
error LeafCannotBeZero();
error LeafAlreadyExists();
error LeafDoesNotExist();

/// @title Lean Incremental binary Merkle tree.
/// @dev The LeanIMT is an optimized version of the BinaryIMT.
/// This implementation eliminates the use of zeroes, and make the tree depth dynamic.
/// When a node doesn't have the right child, instead of using a zero hash as in the BinaryIMT,
/// the node's value becomes that of its left child. Furthermore, rather than utilizing a static tree depth,
/// it is updated based on the number of leaves in the tree. This approach
/// results in the calculation of significantly fewer hashes, making the tree more efficient.
library InternalLeanIMT {
    /// @dev Inserts a new leaf into the incremental merkle tree.
    /// The function ensures that the leaf is valid according to the
    /// constraints of the tree and then updates the tree's structure accordingly.
    /// @param self: A storage reference to the 'LeanIMTData' struct.
    /// @param leaf: The value of the new leaf to be inserted into the tree.
    /// @return The new hash of the node after the leaf has been inserted.
    function _insert(LeanIMTData storage self, uint256 leaf) internal returns (uint256) {
        if (leaf >= SNARK_SCALAR_FIELD) {
            revert LeafGreaterThanSnarkScalarField();
        } else if (leaf == 0) {
            revert LeafCannotBeZero();
        } else if (_has(self, leaf)) {
            revert LeafAlreadyExists();
        }

        uint256 index = self.size;

        // Cache tree depth to optimize gas
        uint256 treeDepth = self.depth;

        // A new insertion can increase a tree's depth by at most 1,
        // and only if the number of leaves supported by the current
        // depth is less than the number of leaves to be supported after insertion.
        if (2 ** treeDepth < index + 1) {
            ++treeDepth;
        }

        self.depth = treeDepth;

        uint256 node = leaf;

        for (uint256 level = 0; level < treeDepth; ) {
            if ((index >> level) & 1 == 1) {
                node = PoseidonT3.hash([self.sideNodes[level], node]);
            } else {
                self.sideNodes[level] = node;
            }

            unchecked {
                ++level;
            }
        }

        self.size = ++index;

        self.sideNodes[treeDepth] = node;
        self.leaves[leaf] = index;

        return node;
    }

    /// @dev Inserts many leaves into the incremental merkle tree.
    /// The function ensures that the leaves are valid according to the
    /// constraints of the tree and then updates the tree's structure accordingly.
    /// @param self: A storage reference to the 'LeanIMTData' struct.
    /// @param leaves: The values of the new leaves to be inserted into the tree.
    /// @return The root after the leaves have been inserted.
    function _insertMany(LeanIMTData storage self, uint256[] calldata leaves) internal returns (uint256) {
        // Cache tree size to optimize gas
        uint256 treeSize = self.size;

        // Check that all the new values are correct to be added.
        for (uint256 i = 0; i < leaves.length; ) {
            if (leaves[i] >= SNARK_SCALAR_FIELD) {
                revert LeafGreaterThanSnarkScalarField();
            } else if (leaves[i] == 0) {
                revert LeafCannotBeZero();
            } else if (_has(self, leaves[i])) {
                revert LeafAlreadyExists();
            }

            self.leaves[leaves[i]] = treeSize + 1 + i;

            unchecked {
                ++i;
            }
        }

        // Array to save the nodes that will be used to create the next level of the tree.
        uint256[] memory currentLevelNewNodes;

        currentLevelNewNodes = leaves;

        // Cache tree depth to optimize gas
        uint256 treeDepth = self.depth;

        // Calculate the depth of the tree after adding the new values.
        // Unlike the 'insert' function, we need a while here as
        // N insertions can increase the tree's depth more than once.
        while (2 ** treeDepth < treeSize + leaves.length) {
            ++treeDepth;
        }

        self.depth = treeDepth;

        // First index to change in every level.
        uint256 currentLevelStartIndex = treeSize;

        // Size of the level used to create the next level.
        uint256 currentLevelSize = treeSize + leaves.length;

        // The index where changes begin at the next level.
        uint256 nextLevelStartIndex = currentLevelStartIndex >> 1;

        // The size of the next level.
        uint256 nextLevelSize = ((currentLevelSize - 1) >> 1) + 1;

        for (uint256 level = 0; level < treeDepth; ) {
            // The number of nodes for the new level that will be created,
            // only the new values, not the entire level.
            uint256 numberOfNewNodes = nextLevelSize - nextLevelStartIndex;
            uint256[] memory nextLevelNewNodes = new uint256[](numberOfNewNodes);
            for (uint256 i = 0; i < numberOfNewNodes; ) {
                uint256 leftNode;

                // Assign the left node using the saved path or the position in the array.
                if ((i + nextLevelStartIndex) * 2 < currentLevelStartIndex) {
                    leftNode = self.sideNodes[level];
                } else {
                    leftNode = currentLevelNewNodes[(i + nextLevelStartIndex) * 2 - currentLevelStartIndex];
                }

                uint256 rightNode;

                // Assign the right node if the value exists.
                if ((i + nextLevelStartIndex) * 2 + 1 < currentLevelSize) {
                    rightNode = currentLevelNewNodes[(i + nextLevelStartIndex) * 2 + 1 - currentLevelStartIndex];
                }

                uint256 parentNode;

                // Assign the parent node.
                // If it has a right child the result will be the hash(leftNode, rightNode) if not,
                // it will be the leftNode.
                if (rightNode != 0) {
                    parentNode = PoseidonT3.hash([leftNode, rightNode]);
                } else {
                    parentNode = leftNode;
                }

                nextLevelNewNodes[i] = parentNode;

                unchecked {
                    ++i;
                }
            }

            // Update the `sideNodes` variable.
            // If `currentLevelSize` is odd, the saved value will be the last value of the array
            // if it is even and there are more than 1 element in `currentLevelNewNodes`, the saved value
            // will be the value before the last one.
            // If it is even and there is only one element, there is no need to save anything because
            // the correct value for this level was already saved before.
            if (currentLevelSize & 1 == 1) {
                self.sideNodes[level] = currentLevelNewNodes[currentLevelNewNodes.length - 1];
            } else if (currentLevelNewNodes.length > 1) {
                self.sideNodes[level] = currentLevelNewNodes[currentLevelNewNodes.length - 2];
            }

            currentLevelStartIndex = nextLevelStartIndex;

            // Calculate the next level startIndex value.
            // It is the position of the parent node which is pos/2.
            nextLevelStartIndex >>= 1;

            // Update the next array that will be used to calculate the next level.
            currentLevelNewNodes = nextLevelNewNodes;

            currentLevelSize = nextLevelSize;

            // Calculate the size of the next level.
            // The size of the next level is (currentLevelSize - 1) / 2 + 1.
            nextLevelSize = ((nextLevelSize - 1) >> 1) + 1;

            unchecked {
                ++level;
            }
        }

        // Update tree size
        self.size = treeSize + leaves.length;

        // Update tree root
        self.sideNodes[treeDepth] = currentLevelNewNodes[0];

        return currentLevelNewNodes[0];
    }

    /// @dev Updates the value of an existing leaf and recalculates hashes
    /// to maintain tree integrity.
    /// @param self: A storage reference to the 'LeanIMTData' struct.
    /// @param oldLeaf: The value of the leaf that is to be updated.
    /// @param newLeaf: The new value that will replace the oldLeaf in the tree.
    /// @param siblingNodes: An array of sibling nodes that are necessary to recalculate the path to the root.
    /// @return The new hash of the updated node after the leaf has been updated.
    function _update(
        LeanIMTData storage self,
        uint256 oldLeaf,
        uint256 newLeaf,
        uint256[] calldata siblingNodes
    ) internal returns (uint256) {
        if (newLeaf >= SNARK_SCALAR_FIELD) {
            revert LeafGreaterThanSnarkScalarField();
        } else if (!_has(self, oldLeaf)) {
            revert LeafDoesNotExist();
        } else if (_has(self, newLeaf)) {
            revert LeafAlreadyExists();
        }

        uint256 index = _indexOf(self, oldLeaf);
        uint256 node = newLeaf;
        uint256 oldRoot = oldLeaf;

        uint256 lastIndex = self.size - 1;
        uint256 i = 0;

        // Cache tree depth to optimize gas
        uint256 treeDepth = self.depth;

        for (uint256 level = 0; level < treeDepth; ) {
            if ((index >> level) & 1 == 1) {
                if (siblingNodes[i] >= SNARK_SCALAR_FIELD) {
                    revert LeafGreaterThanSnarkScalarField();
                }

                node = PoseidonT3.hash([siblingNodes[i], node]);
                oldRoot = PoseidonT3.hash([siblingNodes[i], oldRoot]);

                unchecked {
                    ++i;
                }
            } else {
                if (index >> level != lastIndex >> level) {
                    if (siblingNodes[i] >= SNARK_SCALAR_FIELD) {
                        revert LeafGreaterThanSnarkScalarField();
                    }

                    if (self.sideNodes[level] == oldRoot) {
                        self.sideNodes[level] = node;
                    }

                    node = PoseidonT3.hash([node, siblingNodes[i]]);
                    oldRoot = PoseidonT3.hash([oldRoot, siblingNodes[i]]);

                    unchecked {
                        ++i;
                    }
                } else {
                    self.sideNodes[level] = node;
                }
            }

            unchecked {
                ++level;
            }
        }

        if (oldRoot != _root(self)) {
            revert WrongSiblingNodes();
        }

        self.sideNodes[treeDepth] = node;

        if (newLeaf != 0) {
            self.leaves[newLeaf] = self.leaves[oldLeaf];
        }

        self.leaves[oldLeaf] = 0;

        return node;
    }

    /// @dev Removes a leaf from the tree by setting its value to zero.
    /// This function utilizes the update function to set the leaf's value
    /// to zero and update the tree's state accordingly.
    /// @param self: A storage reference to the 'LeanIMTData' struct.
    /// @param oldLeaf: The value of the leaf to be removed.
    /// @param siblingNodes: An array of sibling nodes required for updating the path to the root after removal.
    /// @return The new root hash of the tree after the leaf has been removed.
    function _remove(
        LeanIMTData storage self,
        uint256 oldLeaf,
        uint256[] calldata siblingNodes
    ) internal returns (uint256) {
        return _update(self, oldLeaf, 0, siblingNodes);
    }

    /// @dev Checks if a leaf exists in the tree.
    /// @param self: A storage reference to the 'LeanIMTData' struct.
    /// @param leaf: The value of the leaf to check for existence.
    /// @return A boolean value indicating whether the leaf exists in the tree.
    function _has(LeanIMTData storage self, uint256 leaf) internal view returns (bool) {
        return self.leaves[leaf] != 0;
    }

    /// @dev Retrieves the index of a given leaf in the tree.
    /// @param self: A storage reference to the 'LeanIMTData' struct.
    /// @param leaf: The value of the leaf whose index is to be found.
    /// @return The index of the specified leaf within the tree. If the leaf is not present, the function
    /// reverts with a custom error.
    function _indexOf(LeanIMTData storage self, uint256 leaf) internal view returns (uint256) {
        if (self.leaves[leaf] == 0) {
            revert LeafDoesNotExist();
        }

        return self.leaves[leaf] - 1;
    }

    /// @dev Retrieves the root of the tree from the 'sideNodes' mapping using the
    /// current tree depth.
    /// @param self: A storage reference to the 'LeanIMTData' struct.
    /// @return The root hash of the tree.
    function _root(LeanIMTData storage self) internal view returns (uint256) {
        return self.sideNodes[self.depth];
    }
}


// File @zk-kit/lean-imt.sol/LeanIMT.sol@v2.0.1

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

library LeanIMT {
    using InternalLeanIMT for *;

    function insert(LeanIMTData storage self, uint256 leaf) public returns (uint256) {
        return InternalLeanIMT._insert(self, leaf);
    }

    function insertMany(LeanIMTData storage self, uint256[] calldata leaves) public returns (uint256) {
        return InternalLeanIMT._insertMany(self, leaves);
    }

    function update(
        LeanIMTData storage self,
        uint256 oldLeaf,
        uint256 newLeaf,
        uint256[] calldata siblingNodes
    ) public returns (uint256) {
        return InternalLeanIMT._update(self, oldLeaf, newLeaf, siblingNodes);
    }

    function remove(
        LeanIMTData storage self,
        uint256 oldLeaf,
        uint256[] calldata siblingNodes
    ) public returns (uint256) {
        return InternalLeanIMT._remove(self, oldLeaf, siblingNodes);
    }

    function has(LeanIMTData storage self, uint256 leaf) public view returns (bool) {
        return InternalLeanIMT._has(self, leaf);
    }

    function indexOf(LeanIMTData storage self, uint256 leaf) public view returns (uint256) {
        return InternalLeanIMT._indexOf(self, leaf);
    }

    function root(LeanIMTData storage self) public view returns (uint256) {
        return InternalLeanIMT._root(self);
    }
}


// File contracts/Verifier.sol

// Original license: SPDX_License_Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.21;

uint256 constant N = 32768;
uint256 constant LOG_N = 15;
uint256 constant NUMBER_OF_PUBLIC_INPUTS = 4;
library HonkVerificationKey {
    function loadVerificationKey() internal pure returns (Honk.VerificationKey memory) {
        Honk.VerificationKey memory vk = Honk.VerificationKey({
            circuitSize: uint256(32768),
            logCircuitSize: uint256(15),
            publicInputsSize: uint256(4),
            ql: Honk.G1Point({ 
               x: uint256(0x1dff82a2cd5978954bf3587b30dec1e79948c4a789d1aea7bbe7cb61b8b88ff2),
               y: uint256(0x03ec42aa2b1ae1047bae71d61ac048cf3bc64bcd0703c5ce1fac991e090f7f34)
            }),
            qr: Honk.G1Point({ 
               x: uint256(0x249bccef7b729d0572730d1a437068fdd212c159e8a3a455974e9b0d7d950f9b),
               y: uint256(0x01834093b1059cd2173dc248a8f45308d798e205be36576894785589f1fd86ac)
            }),
            qo: Honk.G1Point({ 
               x: uint256(0x23b9fd40131e96c082f2783043723710f9f0e55ef18f26167b3363c8c3e7a07e),
               y: uint256(0x0e9430058c740d15b339a049f5c2acf18676c763a33ec0e138f4de3c17a5f3c5)
            }),
            q4: Honk.G1Point({ 
               x: uint256(0x0b040b487ab7948453eb1efa22bd5ca89ad71c1633ba288607a3cb1948c052ba),
               y: uint256(0x0def68841c548097f1c6cb9c26d04df58e97503b570c8414810b89c7b8ea665a)
            }),
            qm: Honk.G1Point({ 
               x: uint256(0x1d8b9b513d11fa3ff33a0fc864b2e2b7f9e623973e7917e1f6518809f78ca474),
               y: uint256(0x0569f3966724cf979677f6b6546993a45e6ff2023af3876032ba33c50b2112e5)
            }),
            qc: Honk.G1Point({ 
               x: uint256(0x17aeed8738f60103ef2a4571da7fef3bf98065ce405c53b5f540630d1e121b25),
               y: uint256(0x2b4672481f4edcb574b16eded6800e1293c2e6b87005d2ea0a992c794f14272e)
            }),
            qArith: Honk.G1Point({ 
               x: uint256(0x13e3277a1dab4dfff20adefec38cfaab41ec34468a637c2529ddcf2bc6540692),
               y: uint256(0x05e134f3d78122fb348239ede4eadfb0810b21d2fe8d93dc4f94bb882db98cf9)
            }),
            qDeltaRange: Honk.G1Point({ 
               x: uint256(0x3023c6b0a9d9cc6fa81697124d42ac7731db3df61bdaafc7c5f343d0ba9c9b90),
               y: uint256(0x0dc844010209e5a179d08bf49eccd6cb458a004e939ed82df5e07081402f8a2a)
            }),
            qElliptic: Honk.G1Point({ 
               x: uint256(0x115896ab4a135555c05a96857efea2c8cb6275fa62ecb8e5759e19242db64f1f),
               y: uint256(0x03b02d4ef83b1501386dfabcb02b723c90f826b20fc48ffe127b871baa38ff31)
            }),
            qAux: Honk.G1Point({ 
               x: uint256(0x243302bee072e7e2832a0f3021e4d6dbe502facd22c19f82f0e8e830bd8a48a4),
               y: uint256(0x295d6a6fd392c4e5684ec5421fc9b561d93c2291fa97bad83595a40e5d983ca2)
            }),
            qLookup: Honk.G1Point({ 
               x: uint256(0x304b1f3f6dbf38013e2451e1d3441b59536d30f6f10b2e3d2536666ce5283221),
               y: uint256(0x276cd8fc9a873e4e071bcba6aff6d9ee4b9bacd691a89401857d9015136a7ef8)
            }),
            qPoseidon2External: Honk.G1Point({ 
               x: uint256(0x07551cee33d0fb4d64008a0cf733d639a5eb359fbafd565e150fa1afb7a3622f),
               y: uint256(0x2003646dca2f35a40bfb221e933c6499aa2d313e25e831515e3a4a932937ce61)
            }),
            qPoseidon2Internal: Honk.G1Point({ 
               x: uint256(0x18fc83c2592ff3304c9e98868a39d8d84b9e2d70ee25aa49cbc515c2ab8b2fdb),
               y: uint256(0x27bcfcc2a82ea6665fc633a8971ee4a528f568a1e8c05a3c778ea703e4b4421d)
            }),
            s1: Honk.G1Point({ 
               x: uint256(0x2e4a6b0e75ce88c763186d1f843fdb5c2377463e0e9229e2856615c028968caf),
               y: uint256(0x0ccfd4f0c073398b5baf13afdbd6fe96dbef55d494dc156b63660230b43de2c5)
            }),
            s2: Honk.G1Point({ 
               x: uint256(0x19592b4a663c90b7d854ae78297cb49f6297a46c38168a579601f5360c4956b5),
               y: uint256(0x074ab6f0af4e82b9496043eb1edadd2188635aca22e783e4b897016ab0ec3b5c)
            }),
            s3: Honk.G1Point({ 
               x: uint256(0x12657a705cf36bdf98957f45eb0eb7207dcf03fff4759ff1ff7eaeda797205b3),
               y: uint256(0x183d82ac814d207a03ed91ee19ef1750481c708880de65d1730ed5296ff8c1c7)
            }),
            s4: Honk.G1Point({ 
               x: uint256(0x1d5702b37d58495623b5f1c73c24a73f1162080bffa7f3db143b1678cc62f8e2),
               y: uint256(0x128b11cc1da4a85d67a882227df85f3bfce363c92563ac7bb16f2f49ccc00a6a)
            }),
            t1: Honk.G1Point({ 
               x: uint256(0x2cdb329f4ac54a9b2a6bb49f35b27881fa6a6bb06a51e41a3addbc63b92a09f2),
               y: uint256(0x09de6f6dce6674dfe0bb9a2d33543b23fa70fdaae3e508356ea287353ff56377)
            }),
            t2: Honk.G1Point({ 
               x: uint256(0x011733a47342be1b62b23b74d39fb6a27677b44284035c618a4cfa6c35918367),
               y: uint256(0x1b6124ff294c0bbe277c398d606ca94bf37bad466915d4b7b1fcfd2ff798705d)
            }),
            t3: Honk.G1Point({ 
               x: uint256(0x233834e0140e5ef7e22c8e9c71b60d1f9ad15ec60b1160db943c043c64e5635b),
               y: uint256(0x2a1e72915741ffdc0d9537378ca015e8943fd1ce6bb8eeb999eb04d9c51b1f4e)
            }),
            t4: Honk.G1Point({ 
               x: uint256(0x2ae1cb509ce1e6f5a706388238a045046c7d1b3a1c534d8d1cd1165deb1b3a33),
               y: uint256(0x1f0a2bdf6edefdfa216746a70719395d6c1f362f7bacfdb326d34457994ca6c1)
            }),
            id1: Honk.G1Point({ 
               x: uint256(0x033597c6bac91d6e9e97a3a006da13b91455a4206d3eb8c7410f11db38968fd9),
               y: uint256(0x2d5a53b19d2289b846a9eb1f252385d55cdc6ac1db4a4939c5b937c708a99947)
            }),
            id2: Honk.G1Point({ 
               x: uint256(0x15eeef43bd644a9f63d8818a5757bf22b874a0bd91cf29865f42cf4e7d470d62),
               y: uint256(0x3044021a3ed46f0e1139afa94f995e1d947243b73433db6c3a1ab5ca00d80702)
            }),
            id3: Honk.G1Point({ 
               x: uint256(0x1f10d63c9a687a3600963738ed3c072a882a8e6fa0613636e39d15b243c6ac07),
               y: uint256(0x0cce27c30ec949506f41422e1535db6f92bbd5a27efaf924306e365f7aac8b1e)
            }),
            id4: Honk.G1Point({ 
               x: uint256(0x182f54847ab1ee45e88337bd762f6a0f85023bb666450d5be21690420e41d934),
               y: uint256(0x2237afa1e73f82ab0fc89c74a8ca5366e3c8e8a27be442b1c87951ed7dff0caa)
            }),
            lagrangeFirst: Honk.G1Point({ 
               x: uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
               y: uint256(0x0000000000000000000000000000000000000000000000000000000000000002)
            }),
            lagrangeLast: Honk.G1Point({ 
               x: uint256(0x2f9aa10db26e2d30cd675ab8c6c2ee15224b06c57b48d673ea72ba420a0449f2),
               y: uint256(0x1a5247225a5b5f650c58186c792b5708a0cbc3bbeffd7a632e7a8e7bf9cb33a0)
            })
        });
        return vk;
    }
}

pragma solidity ^0.8.27;

type Fr is uint256;

using { add as + } for Fr global;
using { sub as - } for Fr global;
using { mul as * } for Fr global;
using { exp as ^ } for Fr global;
using { notEqual as != } for Fr global;
using { equal as == } for Fr global;

uint256 constant MODULUS =
    21888242871839275222246405745257275088548364400416034343698204186575808495617; // Prime field order

Fr constant MINUS_ONE = Fr.wrap(MODULUS - 1);

// Instantiation
library FrLib
{
    function from(uint256 value) internal pure returns(Fr)
    {
        return Fr.wrap(value % MODULUS);
    }

    function fromBytes32(bytes32 value) internal pure returns(Fr)
    {
        return Fr.wrap(uint256(value) % MODULUS);
    }

    function toBytes32(Fr value) internal pure returns(bytes32)
    {
        return bytes32(Fr.unwrap(value));
    }

    function invert(Fr value) internal view returns(Fr)
    {
        uint256 v = Fr.unwrap(value);
        uint256 result;

        // Call the modexp precompile to invert in the field
        assembly
        {
            let free := mload(0x40)
            mstore(free, 0x20)
            mstore(add(free, 0x20), 0x20)
            mstore(add(free, 0x40), 0x20)
            mstore(add(free, 0x60), v)
            mstore(add(free, 0x80), sub(MODULUS, 2))
            mstore(add(free, 0xa0), MODULUS)
            let success := staticcall(gas(), 0x05, free, 0xc0, 0x00, 0x20)
            if iszero(success) {
                revert(0, 0)
            }
            result := mload(0x00)
        }

        return Fr.wrap(result);
    }

    function pow(Fr base, uint256 v) internal view returns(Fr)
    {
        uint256 b = Fr.unwrap(base);
        uint256 result;

        // Call the modexp precompile to invert in the field
        assembly
        {
            let free := mload(0x40)
            mstore(free, 0x20)
            mstore(add(free, 0x20), 0x20)
            mstore(add(free, 0x40), 0x20)
            mstore(add(free, 0x60), b)
            mstore(add(free, 0x80), v)
            mstore(add(free, 0xa0), MODULUS)
            let success := staticcall(gas(), 0x05, free, 0xc0, 0x00, 0x20)
            if iszero(success) {
                revert(0, 0)
            }
            result := mload(0x00)
        }

        return Fr.wrap(result);
    }

    function div(Fr numerator, Fr denominator) internal view returns(Fr)
    {
        return numerator * invert(denominator);
    }

    function sqr(Fr value) internal pure returns (Fr) {
        return value * value;
    }

    function unwrap(Fr value) internal pure returns (uint256) {
        return Fr.unwrap(value);
    }

    function neg(Fr value) internal pure returns (Fr) {
        return Fr.wrap(MODULUS - Fr.unwrap(value));
    }
}

// Free functions
function add(Fr a, Fr b) pure returns(Fr)
{
    return Fr.wrap(addmod(Fr.unwrap(a), Fr.unwrap(b), MODULUS));
}

function mul(Fr a, Fr b) pure returns(Fr)
{
    return Fr.wrap(mulmod(Fr.unwrap(a), Fr.unwrap(b), MODULUS));
}

function sub(Fr a, Fr b) pure returns(Fr)
{
    return Fr.wrap(addmod(Fr.unwrap(a), MODULUS - Fr.unwrap(b), MODULUS));
}

function exp(Fr base, Fr exponent) pure returns(Fr)
{
    if (Fr.unwrap(exponent) == 0) return Fr.wrap(1);

    for (uint256 i = 1; i < Fr.unwrap(exponent); i += i) {
        base = base * base;
    }
    return base;
}

function notEqual(Fr a, Fr b) pure returns(bool)
{
    return Fr.unwrap(a) != Fr.unwrap(b);
}

function equal(Fr a, Fr b) pure returns(bool)
{
    return Fr.unwrap(a) == Fr.unwrap(b);
}

uint256 constant CONST_PROOF_SIZE_LOG_N = 28;

uint256 constant NUMBER_OF_SUBRELATIONS = 26;
uint256 constant BATCHED_RELATION_PARTIAL_LENGTH = 8;
uint256 constant NUMBER_OF_ENTITIES = 40;
uint256 constant NUMBER_UNSHIFTED = 35;
uint256 constant NUMBER_TO_BE_SHIFTED = 5;

// Alphas are used as relation separators so there should be NUMBER_OF_SUBRELATIONS - 1
uint256 constant NUMBER_OF_ALPHAS = 25;

// Prime field order
uint256 constant Q = 21888242871839275222246405745257275088696311157297823662689037894645226208583; // EC group order. F_q
uint256 constant P = 21888242871839275222246405745257275088548364400416034343698204186575808495617; // Prime field order, F_r

// ENUM FOR WIRES
enum WIRE {
    Q_M,
    Q_C,
    Q_L,
    Q_R,
    Q_O,
    Q_4,
    Q_LOOKUP,
    Q_ARITH,
    Q_RANGE,
    Q_ELLIPTIC,
    Q_AUX,
    Q_POSEIDON2_EXTERNAL,
    Q_POSEIDON2_INTERNAL,
    SIGMA_1,
    SIGMA_2,
    SIGMA_3,
    SIGMA_4,
    ID_1,
    ID_2,
    ID_3,
    ID_4,
    TABLE_1,
    TABLE_2,
    TABLE_3,
    TABLE_4,
    LAGRANGE_FIRST,
    LAGRANGE_LAST,
    W_L,
    W_R,
    W_O,
    W_4,
    Z_PERM,
    LOOKUP_INVERSES,
    LOOKUP_READ_COUNTS,
    LOOKUP_READ_TAGS,
    W_L_SHIFT,
    W_R_SHIFT,
    W_O_SHIFT,
    W_4_SHIFT,
    Z_PERM_SHIFT
}

library Honk {
    struct G1Point {
        uint256 x;
        uint256 y;
    }

    struct G1ProofPoint {
        uint256 x_0;
        uint256 x_1;
        uint256 y_0;
        uint256 y_1;
    }

    struct VerificationKey {
        // Misc Params
        uint256 circuitSize;
        uint256 logCircuitSize;
        uint256 publicInputsSize;
        // Selectors
        G1Point qm;
        G1Point qc;
        G1Point ql;
        G1Point qr;
        G1Point qo;
        G1Point q4;
        G1Point qLookup; // Lookup
        G1Point qArith; // Arithmetic widget
        G1Point qDeltaRange; // Delta Range sort
        G1Point qAux; // Auxillary
        G1Point qElliptic; // Auxillary
        G1Point qPoseidon2External;
        G1Point qPoseidon2Internal;
        // Copy cnstraints
        G1Point s1;
        G1Point s2;
        G1Point s3;
        G1Point s4;
        // Copy identity
        G1Point id1;
        G1Point id2;
        G1Point id3;
        G1Point id4;
        // Precomputed lookup table
        G1Point t1;
        G1Point t2;
        G1Point t3;
        G1Point t4;
        // Fixed first and last
        G1Point lagrangeFirst;
        G1Point lagrangeLast;
    }

    struct RelationParameters {
        // challenges
        Fr eta;
        Fr etaTwo;
        Fr etaThree;
        Fr beta;
        Fr gamma;
        // derived
        Fr publicInputsDelta;
    }


    struct Proof {
        // Free wires
        Honk.G1ProofPoint w1;
        Honk.G1ProofPoint w2;
        Honk.G1ProofPoint w3;
        Honk.G1ProofPoint w4;
        // Lookup helpers - Permutations
        Honk.G1ProofPoint zPerm;
        // Lookup helpers - logup
        Honk.G1ProofPoint lookupReadCounts;
        Honk.G1ProofPoint lookupReadTags;
        Honk.G1ProofPoint lookupInverses;
        // Sumcheck
        Fr[BATCHED_RELATION_PARTIAL_LENGTH][CONST_PROOF_SIZE_LOG_N] sumcheckUnivariates;
        Fr[NUMBER_OF_ENTITIES] sumcheckEvaluations;
        // Shplemini
        Honk.G1ProofPoint[CONST_PROOF_SIZE_LOG_N - 1] geminiFoldComms;
        Fr[CONST_PROOF_SIZE_LOG_N] geminiAEvaluations;
        Honk.G1ProofPoint shplonkQ;
        Honk.G1ProofPoint kzgQuotient;
    }
}

// Transcript library to generate fiat shamir challenges
struct Transcript {
    // Oink
    Honk.RelationParameters relationParameters;
    Fr[NUMBER_OF_ALPHAS] alphas;
    Fr[CONST_PROOF_SIZE_LOG_N] gateChallenges;
    // Sumcheck
    Fr[CONST_PROOF_SIZE_LOG_N] sumCheckUChallenges;
    // Gemini
    Fr rho;
    Fr geminiR;
    // Shplonk
    Fr shplonkNu;
    Fr shplonkZ;
}

library TranscriptLib {
    function generateTranscript(Honk.Proof memory proof, bytes32[] calldata publicInputs, uint256 circuitSize, uint256 publicInputsSize, uint256 pubInputsOffset)
        internal
        pure
        returns (Transcript memory t)
    {
        Fr previousChallenge;
        (t.relationParameters, previousChallenge) =
            generateRelationParametersChallenges(proof, publicInputs, circuitSize, publicInputsSize, pubInputsOffset, previousChallenge);

        (t.alphas, previousChallenge) = generateAlphaChallenges(previousChallenge, proof);

        (t.gateChallenges, previousChallenge) = generateGateChallenges(previousChallenge);

        (t.sumCheckUChallenges, previousChallenge) = generateSumcheckChallenges(proof, previousChallenge);

        (t.rho, previousChallenge) = generateRhoChallenge(proof, previousChallenge);

        (t.geminiR, previousChallenge) = generateGeminiRChallenge(proof, previousChallenge);

        (t.shplonkNu, previousChallenge) = generateShplonkNuChallenge(proof, previousChallenge);

        (t.shplonkZ, previousChallenge) = generateShplonkZChallenge(proof, previousChallenge);

        return t;
    }

    function splitChallenge(Fr challenge) internal pure returns (Fr first, Fr second) {
        uint256 challengeU256 = uint256(Fr.unwrap(challenge));
        uint256 lo = challengeU256 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        uint256 hi = challengeU256 >> 128;
        first = FrLib.fromBytes32(bytes32(lo));
        second = FrLib.fromBytes32(bytes32(hi));
    }

    function generateRelationParametersChallenges(
        Honk.Proof memory proof,
        bytes32[] calldata publicInputs,
        uint256 circuitSize,
        uint256 publicInputsSize,
        uint256 pubInputsOffset,
        Fr previousChallenge
    ) internal pure returns (Honk.RelationParameters memory rp, Fr nextPreviousChallenge) {
        (rp.eta, rp.etaTwo, rp.etaThree, previousChallenge) =
            generateEtaChallenge(proof, publicInputs, circuitSize, publicInputsSize, pubInputsOffset);

        (rp.beta, rp.gamma, nextPreviousChallenge) = generateBetaAndGammaChallenges(previousChallenge, proof);

    }

    function generateEtaChallenge(Honk.Proof memory proof, bytes32[] calldata publicInputs, uint256 circuitSize, uint256 publicInputsSize, uint256 pubInputsOffset)
        internal
        pure
        returns (Fr eta, Fr etaTwo, Fr etaThree, Fr previousChallenge)
    {
        bytes32[] memory round0 = new bytes32[](3 + publicInputsSize + 12);
        round0[0] = bytes32(circuitSize);
        round0[1] = bytes32(publicInputsSize);
        round0[2] = bytes32(pubInputsOffset);
        for (uint256 i = 0; i < publicInputsSize; i++) {
            round0[3 + i] = bytes32(publicInputs[i]);
        }

        // Create the first challenge
        // Note: w4 is added to the challenge later on
        round0[3 + publicInputsSize] = bytes32(proof.w1.x_0);
        round0[3 + publicInputsSize + 1] = bytes32(proof.w1.x_1);
        round0[3 + publicInputsSize + 2] = bytes32(proof.w1.y_0);
        round0[3 + publicInputsSize + 3] = bytes32(proof.w1.y_1);
        round0[3 + publicInputsSize + 4] = bytes32(proof.w2.x_0);
        round0[3 + publicInputsSize + 5] = bytes32(proof.w2.x_1);
        round0[3 + publicInputsSize + 6] = bytes32(proof.w2.y_0);
        round0[3 + publicInputsSize + 7] = bytes32(proof.w2.y_1);
        round0[3 + publicInputsSize + 8] = bytes32(proof.w3.x_0);
        round0[3 + publicInputsSize + 9] = bytes32(proof.w3.x_1);
        round0[3 + publicInputsSize + 10] = bytes32(proof.w3.y_0);
        round0[3 + publicInputsSize + 11] = bytes32(proof.w3.y_1);

        previousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(round0)));
        (eta, etaTwo) = splitChallenge(previousChallenge);
        previousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(Fr.unwrap(previousChallenge))));
        Fr unused;
        (etaThree, unused) = splitChallenge(previousChallenge);
    }

    function generateBetaAndGammaChallenges(Fr previousChallenge, Honk.Proof memory proof)
        internal
        pure
        returns (Fr beta, Fr gamma, Fr nextPreviousChallenge)
    {
        bytes32[13] memory round1;
        round1[0] = FrLib.toBytes32(previousChallenge);
        round1[1] = bytes32(proof.lookupReadCounts.x_0);
        round1[2] = bytes32(proof.lookupReadCounts.x_1);
        round1[3] = bytes32(proof.lookupReadCounts.y_0);
        round1[4] = bytes32(proof.lookupReadCounts.y_1);
        round1[5] = bytes32(proof.lookupReadTags.x_0);
        round1[6] = bytes32(proof.lookupReadTags.x_1);
        round1[7] = bytes32(proof.lookupReadTags.y_0);
        round1[8] = bytes32(proof.lookupReadTags.y_1);
        round1[9] = bytes32(proof.w4.x_0);
        round1[10] = bytes32(proof.w4.x_1);
        round1[11] = bytes32(proof.w4.y_0);
        round1[12] = bytes32(proof.w4.y_1);

        nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(round1)));
        (beta, gamma) = splitChallenge(nextPreviousChallenge);
    }

    // Alpha challenges non-linearise the gate contributions
    function generateAlphaChallenges(Fr previousChallenge, Honk.Proof memory proof)
        internal
        pure
        returns (Fr[NUMBER_OF_ALPHAS] memory alphas, Fr nextPreviousChallenge)
    {
        // Generate the original sumcheck alpha 0 by hashing zPerm and zLookup
        uint256[9] memory alpha0;
        alpha0[0] = Fr.unwrap(previousChallenge);
        alpha0[1] = proof.lookupInverses.x_0;
        alpha0[2] = proof.lookupInverses.x_1;
        alpha0[3] = proof.lookupInverses.y_0;
        alpha0[4] = proof.lookupInverses.y_1;
        alpha0[5] = proof.zPerm.x_0;
        alpha0[6] = proof.zPerm.x_1;
        alpha0[7] = proof.zPerm.y_0;
        alpha0[8] = proof.zPerm.y_1;

        nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(alpha0)));
        (alphas[0], alphas[1]) = splitChallenge(nextPreviousChallenge);

        for (uint256 i = 1; i < NUMBER_OF_ALPHAS / 2; i++) {
            nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(Fr.unwrap(nextPreviousChallenge))));
            (alphas[2 * i], alphas[2 * i + 1]) = splitChallenge(nextPreviousChallenge);
        }
        if (((NUMBER_OF_ALPHAS & 1) == 1) && (NUMBER_OF_ALPHAS > 2)) {
            nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(Fr.unwrap(nextPreviousChallenge))));
            Fr unused;
            (alphas[NUMBER_OF_ALPHAS - 1], unused) = splitChallenge(nextPreviousChallenge);
        }
    }

    function generateGateChallenges(Fr previousChallenge)
        internal
        pure
        returns (Fr[CONST_PROOF_SIZE_LOG_N] memory gateChallenges, Fr nextPreviousChallenge)
    {
        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N; i++) {
            previousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(Fr.unwrap(previousChallenge))));
            Fr unused;
            (gateChallenges[i], unused) = splitChallenge(previousChallenge);
        }
        nextPreviousChallenge = previousChallenge;
    }

    function generateSumcheckChallenges(Honk.Proof memory proof, Fr prevChallenge)
        internal
        pure
        returns (Fr[CONST_PROOF_SIZE_LOG_N] memory sumcheckChallenges, Fr nextPreviousChallenge)
    {
        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N; i++) {
            Fr[BATCHED_RELATION_PARTIAL_LENGTH + 1] memory univariateChal;
            univariateChal[0] = prevChallenge;

            for (uint256 j = 0; j < BATCHED_RELATION_PARTIAL_LENGTH; j++) {
                univariateChal[j + 1] = proof.sumcheckUnivariates[i][j];
            }
            prevChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(univariateChal)));
            Fr unused;
            (sumcheckChallenges[i], unused) = splitChallenge(prevChallenge);
        }
        nextPreviousChallenge = prevChallenge;
    }

    function generateRhoChallenge(Honk.Proof memory proof, Fr prevChallenge)
        internal
        pure
        returns (Fr rho, Fr nextPreviousChallenge)
    {
        Fr[NUMBER_OF_ENTITIES + 1] memory rhoChallengeElements;
        rhoChallengeElements[0] = prevChallenge;

        for (uint256 i = 0; i < NUMBER_OF_ENTITIES; i++) {
            rhoChallengeElements[i + 1] = proof.sumcheckEvaluations[i];
        }

        nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(rhoChallengeElements)));
        Fr unused;
        (rho, unused) = splitChallenge(nextPreviousChallenge);
    }

    function generateGeminiRChallenge(Honk.Proof memory proof, Fr prevChallenge)
        internal
        pure
        returns (Fr geminiR, Fr nextPreviousChallenge)
    {
        uint256[(CONST_PROOF_SIZE_LOG_N - 1) * 4 + 1] memory gR;
        gR[0] = Fr.unwrap(prevChallenge);

        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N - 1; i++) {
            gR[1 + i * 4] = proof.geminiFoldComms[i].x_0;
            gR[2 + i * 4] = proof.geminiFoldComms[i].x_1;
            gR[3 + i * 4] = proof.geminiFoldComms[i].y_0;
            gR[4 + i * 4] = proof.geminiFoldComms[i].y_1;
        }

        nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(gR)));
        Fr unused;
        (geminiR, unused) = splitChallenge(nextPreviousChallenge);
    }

    function generateShplonkNuChallenge(Honk.Proof memory proof, Fr prevChallenge)
        internal
        pure
        returns (Fr shplonkNu, Fr nextPreviousChallenge)
    {
        uint256[(CONST_PROOF_SIZE_LOG_N) + 1] memory shplonkNuChallengeElements;
        shplonkNuChallengeElements[0] = Fr.unwrap(prevChallenge);

        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N; i++) {
            shplonkNuChallengeElements[i + 1] = Fr.unwrap(proof.geminiAEvaluations[i]);
        }

        nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(shplonkNuChallengeElements)));
        Fr unused;
        (shplonkNu, unused) = splitChallenge(nextPreviousChallenge);
    }

    function generateShplonkZChallenge(Honk.Proof memory proof, Fr prevChallenge)
        internal
        pure
        returns (Fr shplonkZ, Fr nextPreviousChallenge)
    {
        uint256[5] memory shplonkZChallengeElements;
        shplonkZChallengeElements[0] = Fr.unwrap(prevChallenge);

        shplonkZChallengeElements[1] = proof.shplonkQ.x_0;
        shplonkZChallengeElements[2] = proof.shplonkQ.x_1;
        shplonkZChallengeElements[3] = proof.shplonkQ.y_0;
        shplonkZChallengeElements[4] = proof.shplonkQ.y_1;

        nextPreviousChallenge = FrLib.fromBytes32(keccak256(abi.encodePacked(shplonkZChallengeElements)));
        Fr unused;
        (shplonkZ, unused) = splitChallenge(nextPreviousChallenge);
    }

    function loadProof(bytes calldata proof) internal pure returns (Honk.Proof memory p) {
        // Commitments
        p.w1 = bytesToG1ProofPoint(proof[0x0:0x80]);

        p.w2 = bytesToG1ProofPoint(proof[0x80:0x100]);
        p.w3 = bytesToG1ProofPoint(proof[0x100:0x180]);

        // Lookup / Permutation Helper Commitments
        p.lookupReadCounts = bytesToG1ProofPoint(proof[0x180:0x200]);
        p.lookupReadTags = bytesToG1ProofPoint(proof[0x200:0x280]);
        p.w4 = bytesToG1ProofPoint(proof[0x280:0x300]);
        p.lookupInverses = bytesToG1ProofPoint(proof[0x300:0x380]);
        p.zPerm = bytesToG1ProofPoint(proof[0x380:0x400]);
        uint256 boundary = 0x400;

        // Sumcheck univariates
        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N; i++) {
            for (uint256 j = 0; j < BATCHED_RELATION_PARTIAL_LENGTH; j++) {
                p.sumcheckUnivariates[i][j] = bytesToFr(proof[boundary:boundary + 0x20]);
                boundary += 0x20;
            }
        }
        // Sumcheck evaluations
        for (uint256 i = 0; i < NUMBER_OF_ENTITIES; i++) {
            p.sumcheckEvaluations[i] = bytesToFr(proof[boundary:boundary + 0x20]);
            boundary += 0x20;
        }

        // Gemini
        // Read gemini fold univariates
        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N - 1; i++) {
            p.geminiFoldComms[i] = bytesToG1ProofPoint(proof[boundary:boundary + 0x80]);
            boundary += 0x80;
        }

        // Read gemini a evaluations
        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N; i++) {
            p.geminiAEvaluations[i] = bytesToFr(proof[boundary:boundary + 0x20]);
            boundary += 0x20;
        }

        // Shplonk
        p.shplonkQ = bytesToG1ProofPoint(proof[boundary:boundary + 0x80]);
        boundary = boundary + 0x80;
        // KZG
        p.kzgQuotient = bytesToG1ProofPoint(proof[boundary:boundary + 0x80]);
    }
}


// Fr utility

function bytesToFr(bytes calldata proofSection) pure returns (Fr scalar) {
    require(proofSection.length == 0x20, "invalid bytes scalar");
    scalar = FrLib.fromBytes32(bytes32(proofSection));
}

// EC Point utilities
function convertProofPoint(Honk.G1ProofPoint memory input) pure returns (Honk.G1Point memory) {
    return Honk.G1Point({x: input.x_0 | (input.x_1 << 136), y: input.y_0 | (input.y_1 << 136)});
}

function bytesToG1ProofPoint(bytes calldata proofSection) pure returns (Honk.G1ProofPoint memory point) {
    require(proofSection.length == 0x80, "invalid bytes point");
    point = Honk.G1ProofPoint({
        x_0: uint256(bytes32(proofSection[0x00:0x20])),
        x_1: uint256(bytes32(proofSection[0x20:0x40])),
        y_0: uint256(bytes32(proofSection[0x40:0x60])),
        y_1: uint256(bytes32(proofSection[0x60:0x80]))
    });
}

function negateInplace(Honk.G1Point memory point) pure returns (Honk.G1Point memory) {
    point.y = (Q - point.y) % Q;
    return point;
}

 function pairing(Honk.G1Point memory rhs, Honk.G1Point memory lhs) view returns (bool) {
        bytes memory input = abi.encodePacked(
            rhs.x,
            rhs.y,
            // Fixed G1 point
            uint256(0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2),
            uint256(0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed),
            uint256(0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b),
            uint256(0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa),
            lhs.x,
            lhs.y,
            // G1 point from VK
            uint256(0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1),
            uint256(0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0),
            uint256(0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4),
            uint256(0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55)
        );

        (bool success, bytes memory result) = address(0x08).staticcall(input);
        bool decodedResult = abi.decode(result, (bool));
        return success && decodedResult;
    }


library RelationsLib {
    Fr internal constant GRUMPKIN_CURVE_B_PARAMETER_NEGATED = Fr.wrap(17); // -(-17)

    function accumulateRelationEvaluations(
         Fr[NUMBER_OF_ENTITIES] memory purportedEvaluations,
        Honk.RelationParameters memory rp,
        Fr[NUMBER_OF_ALPHAS] memory alphas,
        Fr powPartialEval
    ) internal pure returns (Fr accumulator) {
        Fr[NUMBER_OF_SUBRELATIONS] memory evaluations;

        // Accumulate all relations in Ultra Honk - each with varying number of subrelations
        accumulateArithmeticRelation(purportedEvaluations, evaluations, powPartialEval);
        accumulatePermutationRelation(purportedEvaluations, rp, evaluations, powPartialEval);
        accumulateLogDerivativeLookupRelation(purportedEvaluations, rp, evaluations, powPartialEval);
        accumulateDeltaRangeRelation(purportedEvaluations, evaluations, powPartialEval);
        accumulateEllipticRelation(purportedEvaluations, evaluations, powPartialEval);
        accumulateAuxillaryRelation(purportedEvaluations, rp, evaluations, powPartialEval);
        accumulatePoseidonExternalRelation(purportedEvaluations, evaluations, powPartialEval);
        accumulatePoseidonInternalRelation(purportedEvaluations, evaluations, powPartialEval);
        // batch the subrelations with the alpha challenges to obtain the full honk relation
        accumulator = scaleAndBatchSubrelations(evaluations, alphas);
    }

    /**
     * Aesthetic helper function that is used to index by enum into proof.sumcheckEvaluations, it avoids
     * the relation checking code being cluttered with uint256 type casting, which is often a different colour in code
     * editors, and thus is noisy.
     */
    function wire(Fr[NUMBER_OF_ENTITIES] memory p, WIRE _wire) internal pure returns (Fr) {
        return p[uint256(_wire)];
    }

    uint256 internal constant NEG_HALF_MODULO_P = 0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9f8000000;
    /**
     * Ultra Arithmetic Relation
     *
     */
    function accumulateArithmeticRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        // Relation 0
        Fr q_arith = wire(p, WIRE.Q_ARITH);
        {
            Fr neg_half = Fr.wrap(NEG_HALF_MODULO_P);

            Fr accum = (q_arith - Fr.wrap(3)) * (wire(p, WIRE.Q_M) * wire(p, WIRE.W_R) * wire(p, WIRE.W_L)) * neg_half;
            accum = accum + (wire(p, WIRE.Q_L) * wire(p, WIRE.W_L)) + (wire(p, WIRE.Q_R) * wire(p, WIRE.W_R))
                + (wire(p, WIRE.Q_O) * wire(p, WIRE.W_O)) + (wire(p, WIRE.Q_4) * wire(p, WIRE.W_4)) + wire(p, WIRE.Q_C);
            accum = accum + (q_arith - Fr.wrap(1)) * wire(p, WIRE.W_4_SHIFT);
            accum = accum * q_arith;
            accum = accum * domainSep;
            evals[0] = accum;
        }

        // Relation 1
        {
            Fr accum = wire(p, WIRE.W_L) + wire(p, WIRE.W_4) - wire(p, WIRE.W_L_SHIFT) + wire(p, WIRE.Q_M);
            accum = accum * (q_arith - Fr.wrap(2));
            accum = accum * (q_arith - Fr.wrap(1));
            accum = accum * q_arith;
            accum = accum * domainSep;
            evals[1] = accum;
        }
    }

    function accumulatePermutationRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Honk.RelationParameters memory rp,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        Fr grand_product_numerator;
        Fr grand_product_denominator;

        {
            Fr num = wire(p, WIRE.W_L) + wire(p, WIRE.ID_1) * rp.beta + rp.gamma;
            num = num * (wire(p, WIRE.W_R) + wire(p, WIRE.ID_2) * rp.beta + rp.gamma);
            num = num * (wire(p, WIRE.W_O) + wire(p, WIRE.ID_3) * rp.beta + rp.gamma);
            num = num * (wire(p, WIRE.W_4) + wire(p, WIRE.ID_4) * rp.beta + rp.gamma);

            grand_product_numerator = num;
        }
        {
            Fr den = wire(p, WIRE.W_L) + wire(p, WIRE.SIGMA_1) * rp.beta + rp.gamma;
            den = den * (wire(p, WIRE.W_R) + wire(p, WIRE.SIGMA_2) * rp.beta + rp.gamma);
            den = den * (wire(p, WIRE.W_O) + wire(p, WIRE.SIGMA_3) * rp.beta + rp.gamma);
            den = den * (wire(p, WIRE.W_4) + wire(p, WIRE.SIGMA_4) * rp.beta + rp.gamma);

            grand_product_denominator = den;
        }

        // Contribution 2
        {
            Fr acc = (wire(p, WIRE.Z_PERM) + wire(p, WIRE.LAGRANGE_FIRST)) * grand_product_numerator;

            acc = acc
                - (
                    (wire(p, WIRE.Z_PERM_SHIFT) + (wire(p, WIRE.LAGRANGE_LAST) * rp.publicInputsDelta))
                        * grand_product_denominator
                );
            acc = acc * domainSep;
            evals[2] = acc;
        }

        // Contribution 3
        {
            Fr acc = (wire(p, WIRE.LAGRANGE_LAST) * wire(p, WIRE.Z_PERM_SHIFT)) * domainSep;
            evals[3] = acc;
        }
    }

    function accumulateLogDerivativeLookupRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Honk.RelationParameters memory rp,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        Fr write_term;
        Fr read_term;

        // Calculate the write term (the table accumulation)
        {
            write_term = wire(p, WIRE.TABLE_1) + rp.gamma + (wire(p, WIRE.TABLE_2) * rp.eta)
                + (wire(p, WIRE.TABLE_3) * rp.etaTwo) + (wire(p, WIRE.TABLE_4) * rp.etaThree);
        }

        // Calculate the write term
        {
            Fr derived_entry_1 = wire(p, WIRE.W_L) + rp.gamma + (wire(p, WIRE.Q_R) * wire(p, WIRE.W_L_SHIFT));
            Fr derived_entry_2 = wire(p, WIRE.W_R) + wire(p, WIRE.Q_M) * wire(p, WIRE.W_R_SHIFT);
            Fr derived_entry_3 = wire(p, WIRE.W_O) + wire(p, WIRE.Q_C) * wire(p, WIRE.W_O_SHIFT);

            read_term = derived_entry_1 + (derived_entry_2 * rp.eta) + (derived_entry_3 * rp.etaTwo)
                + (wire(p, WIRE.Q_O) * rp.etaThree);
        }

        Fr read_inverse = wire(p, WIRE.LOOKUP_INVERSES) * write_term;
        Fr write_inverse = wire(p, WIRE.LOOKUP_INVERSES) * read_term;

        Fr inverse_exists_xor = wire(p, WIRE.LOOKUP_READ_TAGS) + wire(p, WIRE.Q_LOOKUP)
            - (wire(p, WIRE.LOOKUP_READ_TAGS) * wire(p, WIRE.Q_LOOKUP));

        // Inverse calculated correctly relation
        Fr accumulatorNone = read_term * write_term * wire(p, WIRE.LOOKUP_INVERSES) - inverse_exists_xor;
        accumulatorNone = accumulatorNone * domainSep;

        // Inverse
        Fr accumulatorOne = wire(p, WIRE.Q_LOOKUP) * read_inverse - wire(p, WIRE.LOOKUP_READ_COUNTS) * write_inverse;

        evals[4] = accumulatorNone;
        evals[5] = accumulatorOne;
    }

    function accumulateDeltaRangeRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        Fr minus_one = Fr.wrap(0) - Fr.wrap(1);
        Fr minus_two = Fr.wrap(0) - Fr.wrap(2);
        Fr minus_three = Fr.wrap(0) - Fr.wrap(3);

        // Compute wire differences
        Fr delta_1 = wire(p, WIRE.W_R) - wire(p, WIRE.W_L);
        Fr delta_2 = wire(p, WIRE.W_O) - wire(p, WIRE.W_R);
        Fr delta_3 = wire(p, WIRE.W_4) - wire(p, WIRE.W_O);
        Fr delta_4 = wire(p, WIRE.W_L_SHIFT) - wire(p, WIRE.W_4);

        // Contribution 6
        {
            Fr acc = delta_1;
            acc = acc * (delta_1 + minus_one);
            acc = acc * (delta_1 + minus_two);
            acc = acc * (delta_1 + minus_three);
            acc = acc * wire(p, WIRE.Q_RANGE);
            acc = acc * domainSep;
            evals[6] = acc;
        }

        // Contribution 7
        {
            Fr acc = delta_2;
            acc = acc * (delta_2 + minus_one);
            acc = acc * (delta_2 + minus_two);
            acc = acc * (delta_2 + minus_three);
            acc = acc * wire(p, WIRE.Q_RANGE);
            acc = acc * domainSep;
            evals[7] = acc;
        }

        // Contribution 8
        {
            Fr acc = delta_3;
            acc = acc * (delta_3 + minus_one);
            acc = acc * (delta_3 + minus_two);
            acc = acc * (delta_3 + minus_three);
            acc = acc * wire(p, WIRE.Q_RANGE);
            acc = acc * domainSep;
            evals[8] = acc;
        }

        // Contribution 9
        {
            Fr acc = delta_4;
            acc = acc * (delta_4 + minus_one);
            acc = acc * (delta_4 + minus_two);
            acc = acc * (delta_4 + minus_three);
            acc = acc * wire(p, WIRE.Q_RANGE);
            acc = acc * domainSep;
            evals[9] = acc;
        }
    }

    struct EllipticParams {
        // Points
        Fr x_1;
        Fr y_1;
        Fr x_2;
        Fr y_2;
        Fr y_3;
        Fr x_3;
        // push accumulators into memory
        Fr x_double_identity;
    }

    function accumulateEllipticRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        EllipticParams memory ep;
        ep.x_1 = wire(p, WIRE.W_R);
        ep.y_1 = wire(p, WIRE.W_O);

        ep.x_2 = wire(p, WIRE.W_L_SHIFT);
        ep.y_2 = wire(p, WIRE.W_4_SHIFT);
        ep.y_3 = wire(p, WIRE.W_O_SHIFT);
        ep.x_3 = wire(p, WIRE.W_R_SHIFT);

        Fr q_sign = wire(p, WIRE.Q_L);
        Fr q_is_double = wire(p, WIRE.Q_M);

        // Contribution 10 point addition, x-coordinate check
        // q_elliptic * (x3 + x2 + x1)(x2 - x1)(x2 - x1) - y2^2 - y1^2 + 2(y2y1)*q_sign = 0
        Fr x_diff = (ep.x_2 - ep.x_1);
        Fr y1_sqr = (ep.y_1 * ep.y_1);
        {
            // Move to top
            Fr partialEval = domainSep;

            Fr y2_sqr = (ep.y_2 * ep.y_2);
            Fr y1y2 = ep.y_1 * ep.y_2 * q_sign;
            Fr x_add_identity = (ep.x_3 + ep.x_2 + ep.x_1);
            x_add_identity = x_add_identity * x_diff * x_diff;
            x_add_identity = x_add_identity - y2_sqr - y1_sqr + y1y2 + y1y2;

            evals[10] = x_add_identity * partialEval * wire(p, WIRE.Q_ELLIPTIC) * (Fr.wrap(1) - q_is_double);
        }

        // Contribution 11 point addition, x-coordinate check
        // q_elliptic * (q_sign * y1 + y3)(x2 - x1) + (x3 - x1)(y2 - q_sign * y1) = 0
        {
            Fr y1_plus_y3 = ep.y_1 + ep.y_3;
            Fr y_diff = ep.y_2 * q_sign - ep.y_1;
            Fr y_add_identity = y1_plus_y3 * x_diff + (ep.x_3 - ep.x_1) * y_diff;
            evals[11] = y_add_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * (Fr.wrap(1) - q_is_double);
        }

        // Contribution 10 point doubling, x-coordinate check
        // (x3 + x1 + x1) (4y1*y1) - 9 * x1 * x1 * x1 * x1 = 0
        // N.B. we're using the equivalence x1*x1*x1 === y1*y1 - curve_b to reduce degree by 1
        {
            Fr x_pow_4 = (y1_sqr + GRUMPKIN_CURVE_B_PARAMETER_NEGATED) * ep.x_1;
            Fr y1_sqr_mul_4 = y1_sqr + y1_sqr;
            y1_sqr_mul_4 = y1_sqr_mul_4 + y1_sqr_mul_4;
            Fr x1_pow_4_mul_9 = x_pow_4 * Fr.wrap(9);

            // NOTE: pushed into memory (stack >:'( )
            ep.x_double_identity = (ep.x_3 + ep.x_1 + ep.x_1) * y1_sqr_mul_4 - x1_pow_4_mul_9;

            Fr acc = ep.x_double_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * q_is_double;
            evals[10] = evals[10] + acc;
        }

        // Contribution 11 point doubling, y-coordinate check
        // (y1 + y1) (2y1) - (3 * x1 * x1)(x1 - x3) = 0
        {
            Fr x1_sqr_mul_3 = (ep.x_1 + ep.x_1 + ep.x_1) * ep.x_1;
            Fr y_double_identity = x1_sqr_mul_3 * (ep.x_1 - ep.x_3) - (ep.y_1 + ep.y_1) * (ep.y_1 + ep.y_3);
            evals[11] = evals[11] + y_double_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * q_is_double;
        }
    }

    // Constants for the auxiliary relation
    Fr constant LIMB_SIZE = Fr.wrap(uint256(1) << 68);
    Fr constant SUBLIMB_SHIFT = Fr.wrap(uint256(1) << 14);

    // Parameters used within the Auxiliary Relation
    // A struct is used to work around stack too deep. This relation has alot of variables
    struct AuxParams {
        Fr limb_subproduct;
        Fr non_native_field_gate_1;
        Fr non_native_field_gate_2;
        Fr non_native_field_gate_3;
        Fr limb_accumulator_1;
        Fr limb_accumulator_2;
        Fr memory_record_check;
        Fr partial_record_check;
        Fr next_gate_access_type;
        Fr record_delta;
        Fr index_delta;
        Fr adjacent_values_match_if_adjacent_indices_match;
        Fr adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation;
        Fr access_check;
        Fr next_gate_access_type_is_boolean;
        Fr ROM_consistency_check_identity;
        Fr RAM_consistency_check_identity;
        Fr timestamp_delta;
        Fr RAM_timestamp_check_identity;
        Fr memory_identity;
        Fr index_is_monotonically_increasing;
        Fr auxiliary_identity;
    }

    function accumulateAuxillaryRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Honk.RelationParameters memory rp,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        AuxParams memory ap;

        /**
         * Contribution 12
         * Non native field arithmetic gate 2
         * deg 4
         *
         *             _                                                                               _
         *            /   _                   _                               _       14                \
         * q_2 . q_4 |   (w_1 . w_2) + (w_1 . w_2) + (w_1 . w_4 + w_2 . w_3 - w_3) . 2    - w_3 - w_4   |
         *            \_                                                                               _/
         *
         *
         */
        ap.limb_subproduct = wire(p, WIRE.W_L) * wire(p, WIRE.W_R_SHIFT) + wire(p, WIRE.W_L_SHIFT) * wire(p, WIRE.W_R);
        ap.non_native_field_gate_2 =
            (wire(p, WIRE.W_L) * wire(p, WIRE.W_4) + wire(p, WIRE.W_R) * wire(p, WIRE.W_O) - wire(p, WIRE.W_O_SHIFT));
        ap.non_native_field_gate_2 = ap.non_native_field_gate_2 * LIMB_SIZE;
        ap.non_native_field_gate_2 = ap.non_native_field_gate_2 - wire(p, WIRE.W_4_SHIFT);
        ap.non_native_field_gate_2 = ap.non_native_field_gate_2 + ap.limb_subproduct;
        ap.non_native_field_gate_2 = ap.non_native_field_gate_2 * wire(p, WIRE.Q_4);

        ap.limb_subproduct = ap.limb_subproduct * LIMB_SIZE;
        ap.limb_subproduct = ap.limb_subproduct + (wire(p, WIRE.W_L_SHIFT) * wire(p, WIRE.W_R_SHIFT));
        ap.non_native_field_gate_1 = ap.limb_subproduct;
        ap.non_native_field_gate_1 = ap.non_native_field_gate_1 - (wire(p, WIRE.W_O) + wire(p, WIRE.W_4));
        ap.non_native_field_gate_1 = ap.non_native_field_gate_1 * wire(p, WIRE.Q_O);

        ap.non_native_field_gate_3 = ap.limb_subproduct;
        ap.non_native_field_gate_3 = ap.non_native_field_gate_3 + wire(p, WIRE.W_4);
        ap.non_native_field_gate_3 = ap.non_native_field_gate_3 - (wire(p, WIRE.W_O_SHIFT) + wire(p, WIRE.W_4_SHIFT));
        ap.non_native_field_gate_3 = ap.non_native_field_gate_3 * wire(p, WIRE.Q_M);

        Fr non_native_field_identity =
            ap.non_native_field_gate_1 + ap.non_native_field_gate_2 + ap.non_native_field_gate_3;
        non_native_field_identity = non_native_field_identity * wire(p, WIRE.Q_R);

        // ((((w2' * 2^14 + w1') * 2^14 + w3) * 2^14 + w2) * 2^14 + w1 - w4) * qm
        // deg 2
        ap.limb_accumulator_1 = wire(p, WIRE.W_R_SHIFT) * SUBLIMB_SHIFT;
        ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_L_SHIFT);
        ap.limb_accumulator_1 = ap.limb_accumulator_1 * SUBLIMB_SHIFT;
        ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_O);
        ap.limb_accumulator_1 = ap.limb_accumulator_1 * SUBLIMB_SHIFT;
        ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_R);
        ap.limb_accumulator_1 = ap.limb_accumulator_1 * SUBLIMB_SHIFT;
        ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_L);
        ap.limb_accumulator_1 = ap.limb_accumulator_1 - wire(p, WIRE.W_4);
        ap.limb_accumulator_1 = ap.limb_accumulator_1 * wire(p, WIRE.Q_4);

        // ((((w3' * 2^14 + w2') * 2^14 + w1') * 2^14 + w4) * 2^14 + w3 - w4') * qm
        // deg 2
        ap.limb_accumulator_2 = wire(p, WIRE.W_O_SHIFT) * SUBLIMB_SHIFT;
        ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_R_SHIFT);
        ap.limb_accumulator_2 = ap.limb_accumulator_2 * SUBLIMB_SHIFT;
        ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_L_SHIFT);
        ap.limb_accumulator_2 = ap.limb_accumulator_2 * SUBLIMB_SHIFT;
        ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_4);
        ap.limb_accumulator_2 = ap.limb_accumulator_2 * SUBLIMB_SHIFT;
        ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_O);
        ap.limb_accumulator_2 = ap.limb_accumulator_2 - wire(p, WIRE.W_4_SHIFT);
        ap.limb_accumulator_2 = ap.limb_accumulator_2 * wire(p, WIRE.Q_M);

        Fr limb_accumulator_identity = ap.limb_accumulator_1 + ap.limb_accumulator_2;
        limb_accumulator_identity = limb_accumulator_identity * wire(p, WIRE.Q_O); //  deg 3

        /**
         * MEMORY
         *
         * A RAM memory record contains a tuple of the following fields:
         *  * i: `index` of memory cell being accessed
         *  * t: `timestamp` of memory cell being accessed (used for RAM, set to 0 for ROM)
         *  * v: `value` of memory cell being accessed
         *  * a: `access` type of record. read: 0 = read, 1 = write
         *  * r: `record` of memory cell. record = access + index * eta + timestamp * eta_two + value * eta_three
         *
         * A ROM memory record contains a tuple of the following fields:
         *  * i: `index` of memory cell being accessed
         *  * v: `value1` of memory cell being accessed (ROM tables can store up to 2 values per index)
         *  * v2:`value2` of memory cell being accessed (ROM tables can store up to 2 values per index)
         *  * r: `record` of memory cell. record = index * eta + value2 * eta_two + value1 * eta_three
         *
         *  When performing a read/write access, the values of i, t, v, v2, a, r are stored in the following wires +
         * selectors, depending on whether the gate is a RAM read/write or a ROM read
         *
         *  | gate type | i  | v2/t  |  v | a  | r  |
         *  | --------- | -- | ----- | -- | -- | -- |
         *  | ROM       | w1 | w2    | w3 | -- | w4 |
         *  | RAM       | w1 | w2    | w3 | qc | w4 |
         *
         * (for accesses where `index` is a circuit constant, it is assumed the circuit will apply a copy constraint on
         * `w2` to fix its value)
         *
         *
         */

        /**
         * Memory Record Check
         * Partial degree: 1
         * Total degree: 4
         *
         * A ROM/ROM access gate can be evaluated with the identity:
         *
         * qc + w1 \eta + w2 \eta_two + w3 \eta_three - w4 = 0
         *
         * For ROM gates, qc = 0
         */
        ap.memory_record_check = wire(p, WIRE.W_O) * rp.etaThree;
        ap.memory_record_check = ap.memory_record_check + (wire(p, WIRE.W_R) * rp.etaTwo);
        ap.memory_record_check = ap.memory_record_check + (wire(p, WIRE.W_L) * rp.eta);
        ap.memory_record_check = ap.memory_record_check + wire(p, WIRE.Q_C);
        ap.partial_record_check = ap.memory_record_check; // used in RAM consistency check; deg 1 or 4
        ap.memory_record_check = ap.memory_record_check - wire(p, WIRE.W_4);

        /**
         * Contribution 13 & 14
         * ROM Consistency Check
         * Partial degree: 1
         * Total degree: 4
         *
         * For every ROM read, a set equivalence check is applied between the record witnesses, and a second set of
         * records that are sorted.
         *
         * We apply the following checks for the sorted records:
         *
         * 1. w1, w2, w3 correctly map to 'index', 'v1, 'v2' for a given record value at w4
         * 2. index values for adjacent records are monotonically increasing
         * 3. if, at gate i, index_i == index_{i + 1}, then value1_i == value1_{i + 1} and value2_i == value2_{i + 1}
         *
         */
        ap.index_delta = wire(p, WIRE.W_L_SHIFT) - wire(p, WIRE.W_L);
        ap.record_delta = wire(p, WIRE.W_4_SHIFT) - wire(p, WIRE.W_4);

        ap.index_is_monotonically_increasing = ap.index_delta * ap.index_delta - ap.index_delta; // deg 2

        ap.adjacent_values_match_if_adjacent_indices_match = (ap.index_delta * MINUS_ONE + Fr.wrap(1)) * ap.record_delta; // deg 2

        evals[13] = ap.adjacent_values_match_if_adjacent_indices_match * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R))
            * (wire(p, WIRE.Q_AUX) * domainSep); // deg 5
        evals[14] = ap.index_is_monotonically_increasing * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R))
            * (wire(p, WIRE.Q_AUX) * domainSep); // deg 5

        ap.ROM_consistency_check_identity = ap.memory_record_check * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R)); // deg 3 or 7

        /**
         * Contributions 15,16,17
         * RAM Consistency Check
         *
         * The 'access' type of the record is extracted with the expression `w_4 - ap.partial_record_check`
         * (i.e. for an honest Prover `w1 * eta + w2 * eta^2 + w3 * eta^3 - w4 = access`.
         * This is validated by requiring `access` to be boolean
         *
         * For two adjacent entries in the sorted list if _both_
         *  A) index values match
         *  B) adjacent access value is 0 (i.e. next gate is a READ)
         * then
         *  C) both values must match.
         * The gate boolean check is
         * (A && B) => C  === !(A && B) || C ===  !A || !B || C
         *
         * N.B. it is the responsibility of the circuit writer to ensure that every RAM cell is initialized
         * with a WRITE operation.
         */
        Fr access_type = (wire(p, WIRE.W_4) - ap.partial_record_check); // will be 0 or 1 for honest Prover; deg 1 or 4
        ap.access_check = access_type * access_type - access_type; // check value is 0 or 1; deg 2 or 8

        ap.next_gate_access_type = wire(p, WIRE.W_O_SHIFT) * rp.etaThree;
        ap.next_gate_access_type = ap.next_gate_access_type + (wire(p, WIRE.W_R_SHIFT) * rp.etaTwo);
        ap.next_gate_access_type = ap.next_gate_access_type + (wire(p, WIRE.W_L_SHIFT) * rp.eta);
        ap.next_gate_access_type = wire(p, WIRE.W_4_SHIFT) - ap.next_gate_access_type;

        Fr value_delta = wire(p, WIRE.W_O_SHIFT) - wire(p, WIRE.W_O);
        ap.adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation = (
            ap.index_delta * MINUS_ONE + Fr.wrap(1)
        ) * value_delta * (ap.next_gate_access_type * MINUS_ONE + Fr.wrap(1)); // deg 3 or 6

        // We can't apply the RAM consistency check identity on the final entry in the sorted list (the wires in the
        // next gate would make the identity fail).  We need to validate that its 'access type' bool is correct. Can't
        // do  with an arithmetic gate because of the  `eta` factors. We need to check that the *next* gate's access
        // type is  correct, to cover this edge case
        // deg 2 or 4
        ap.next_gate_access_type_is_boolean =
            ap.next_gate_access_type * ap.next_gate_access_type - ap.next_gate_access_type;

        // Putting it all together...
        evals[15] = ap.adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation
            * (wire(p, WIRE.Q_ARITH)) * (wire(p, WIRE.Q_AUX) * domainSep); // deg 5 or 8
        evals[16] = ap.index_is_monotonically_increasing * (wire(p, WIRE.Q_ARITH)) * (wire(p, WIRE.Q_AUX) * domainSep); // deg 4
        evals[17] = ap.next_gate_access_type_is_boolean * (wire(p, WIRE.Q_ARITH)) * (wire(p, WIRE.Q_AUX) * domainSep); // deg 4 or 6

        ap.RAM_consistency_check_identity = ap.access_check * (wire(p, WIRE.Q_ARITH)); // deg 3 or 9

        /**
         * RAM Timestamp Consistency Check
         *
         * | w1 | w2 | w3 | w4 |
         * | index | timestamp | timestamp_check | -- |
         *
         * Let delta_index = index_{i + 1} - index_{i}
         *
         * Iff delta_index == 0, timestamp_check = timestamp_{i + 1} - timestamp_i
         * Else timestamp_check = 0
         */
        ap.timestamp_delta = wire(p, WIRE.W_R_SHIFT) - wire(p, WIRE.W_R);
        ap.RAM_timestamp_check_identity =
            (ap.index_delta * MINUS_ONE + Fr.wrap(1)) * ap.timestamp_delta - wire(p, WIRE.W_O); // deg 3

        /**
         * Complete Contribution 12
         * The complete RAM/ROM memory identity
         * Partial degree:
         */
        ap.memory_identity = ap.ROM_consistency_check_identity; // deg 3 or 6
        ap.memory_identity =
            ap.memory_identity + ap.RAM_timestamp_check_identity * (wire(p, WIRE.Q_4) * wire(p, WIRE.Q_L)); // deg 4
        ap.memory_identity = ap.memory_identity + ap.memory_record_check * (wire(p, WIRE.Q_M) * wire(p, WIRE.Q_L)); // deg 3 or 6
        ap.memory_identity = ap.memory_identity + ap.RAM_consistency_check_identity; // deg 3 or 9

        // (deg 3 or 9) + (deg 4) + (deg 3)
        ap.auxiliary_identity = ap.memory_identity + non_native_field_identity + limb_accumulator_identity;
        ap.auxiliary_identity = ap.auxiliary_identity * (wire(p, WIRE.Q_AUX) * domainSep); // deg 4 or 10
        evals[12] = ap.auxiliary_identity;
    }

    struct PoseidonExternalParams {
        Fr s1;
        Fr s2;
        Fr s3;
        Fr s4;
        Fr u1;
        Fr u2;
        Fr u3;
        Fr u4;
        Fr t0;
        Fr t1;
        Fr t2;
        Fr t3;
        Fr v1;
        Fr v2;
        Fr v3;
        Fr v4;
        Fr q_pos_by_scaling;
    }

    function accumulatePoseidonExternalRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        PoseidonExternalParams memory ep;

        ep.s1 = wire(p, WIRE.W_L) + wire(p, WIRE.Q_L);
        ep.s2 = wire(p, WIRE.W_R) + wire(p, WIRE.Q_R);
        ep.s3 = wire(p, WIRE.W_O) + wire(p, WIRE.Q_O);
        ep.s4 = wire(p, WIRE.W_4) + wire(p, WIRE.Q_4);

        ep.u1 = ep.s1 * ep.s1 * ep.s1 * ep.s1 * ep.s1;
        ep.u2 = ep.s2 * ep.s2 * ep.s2 * ep.s2 * ep.s2;
        ep.u3 = ep.s3 * ep.s3 * ep.s3 * ep.s3 * ep.s3;
        ep.u4 = ep.s4 * ep.s4 * ep.s4 * ep.s4 * ep.s4;
        // matrix mul v = M_E * u with 14 additions
        ep.t0 = ep.u1 + ep.u2; // u_1 + u_2
        ep.t1 = ep.u3 + ep.u4; // u_3 + u_4
        ep.t2 = ep.u2 + ep.u2 + ep.t1; // 2u_2
        // ep.t2 += ep.t1; // 2u_2 + u_3 + u_4
        ep.t3 = ep.u4 + ep.u4 + ep.t0; // 2u_4
        // ep.t3 += ep.t0; // u_1 + u_2 + 2u_4
        ep.v4 = ep.t1 + ep.t1;
        ep.v4 = ep.v4 + ep.v4 + ep.t3;
        // ep.v4 += ep.t3; // u_1 + u_2 + 4u_3 + 6u_4
        ep.v2 = ep.t0 + ep.t0;
        ep.v2 = ep.v2 + ep.v2 + ep.t2;
        // ep.v2 += ep.t2; // 4u_1 + 6u_2 + u_3 + u_4
        ep.v1 = ep.t3 + ep.v2; // 5u_1 + 7u_2 + u_3 + 3u_4
        ep.v3 = ep.t2 + ep.v4; // u_1 + 3u_2 + 5u_3 + 7u_4

        ep.q_pos_by_scaling = wire(p, WIRE.Q_POSEIDON2_EXTERNAL) * domainSep;
        evals[18] = evals[18] + ep.q_pos_by_scaling * (ep.v1 - wire(p, WIRE.W_L_SHIFT));

        evals[19] = evals[19] + ep.q_pos_by_scaling * (ep.v2 - wire(p, WIRE.W_R_SHIFT));

        evals[20] = evals[20] + ep.q_pos_by_scaling * (ep.v3 - wire(p, WIRE.W_O_SHIFT));

        evals[21] = evals[21] + ep.q_pos_by_scaling * (ep.v4 - wire(p, WIRE.W_4_SHIFT));
    }

    struct PoseidonInternalParams {
        Fr u1;
        Fr u2;
        Fr u3;
        Fr u4;
        Fr u_sum;
        Fr v1;
        Fr v2;
        Fr v3;
        Fr v4;
        Fr s1;
        Fr q_pos_by_scaling;
    }

    function accumulatePoseidonInternalRelation(
        Fr[NUMBER_OF_ENTITIES] memory p,
        Fr[NUMBER_OF_SUBRELATIONS] memory evals,
        Fr domainSep
    ) internal pure {
        PoseidonInternalParams memory ip;

        Fr[4] memory INTERNAL_MATRIX_DIAGONAL = [
            FrLib.from(0x10dc6e9c006ea38b04b1e03b4bd9490c0d03f98929ca1d7fb56821fd19d3b6e7),
            FrLib.from(0x0c28145b6a44df3e0149b3d0a30b3bb599df9756d4dd9b84a86b38cfb45a740b),
            FrLib.from(0x00544b8338791518b2c7645a50392798b21f75bb60e3596170067d00141cac15),
            FrLib.from(0x222c01175718386f2e2e82eb122789e352e105a3b8fa852613bc534433ee428b)
        ];

        // add round constants
        ip.s1 = wire(p, WIRE.W_L) + wire(p, WIRE.Q_L);

        // apply s-box round
        ip.u1 = ip.s1 * ip.s1 * ip.s1 * ip.s1 * ip.s1;
        ip.u2 = wire(p, WIRE.W_R);
        ip.u3 = wire(p, WIRE.W_O);
        ip.u4 = wire(p, WIRE.W_4);

        // matrix mul with v = M_I * u 4 muls and 7 additions
        ip.u_sum = ip.u1 + ip.u2 + ip.u3 + ip.u4;

        ip.q_pos_by_scaling = wire(p, WIRE.Q_POSEIDON2_INTERNAL) * domainSep;

        ip.v1 = ip.u1 * INTERNAL_MATRIX_DIAGONAL[0] + ip.u_sum;
        evals[22] = evals[22] + ip.q_pos_by_scaling * (ip.v1 - wire(p, WIRE.W_L_SHIFT));

        ip.v2 = ip.u2 * INTERNAL_MATRIX_DIAGONAL[1] + ip.u_sum;
        evals[23] = evals[23] + ip.q_pos_by_scaling * (ip.v2 - wire(p, WIRE.W_R_SHIFT));

        ip.v3 = ip.u3 * INTERNAL_MATRIX_DIAGONAL[2] + ip.u_sum;
        evals[24] = evals[24] + ip.q_pos_by_scaling * (ip.v3 - wire(p, WIRE.W_O_SHIFT));

        ip.v4 = ip.u4 * INTERNAL_MATRIX_DIAGONAL[3] + ip.u_sum;
        evals[25] = evals[25] + ip.q_pos_by_scaling * (ip.v4 - wire(p, WIRE.W_4_SHIFT));
    }

    function scaleAndBatchSubrelations(
        Fr[NUMBER_OF_SUBRELATIONS] memory evaluations,
        Fr[NUMBER_OF_ALPHAS] memory subrelationChallenges
    ) internal pure returns (Fr accumulator) {
        accumulator = accumulator + evaluations[0];

        for (uint256 i = 1; i < NUMBER_OF_SUBRELATIONS; ++i) {
            accumulator = accumulator + evaluations[i] * subrelationChallenges[i - 1];
        }
    }
}

struct ShpleminiIntermediates {
    Fr unshiftedScalar;
    Fr shiftedScalar;
    // Scalar to be multiplied by [1]₁
    Fr constantTermAccumulator;
    // Accumulator for powers of rho
    Fr batchingChallenge;
    // Linear combination of multilinear (sumcheck) evaluations and powers of rho
    Fr batchedEvaluation;
    // 1/(z - r^{2^i}) for i = 0, ..., logSize, dynamically updated
    Fr posInvertedDenominator;
    // 1/(z + r^{2^i}) for i = 0, ..., logSize, dynamically updated
    Fr negInvertedDenominator;
    // v^{2i} * 1/(z - r^{2^i})
    Fr scalingFactorPos;
    // v^{2i+1} * 1/(z + r^{2^i})
    Fr scalingFactorNeg;
    // // Fold_i(r^{2^i}) reconstructed by Verifier
    // Fr[CONST_PROOF_SIZE_LOG_N] foldPosEvaluations;
}

library CommitmentSchemeLib {
    using FrLib for Fr;

    function computeSquares(Fr r) internal pure returns (Fr[CONST_PROOF_SIZE_LOG_N] memory squares) {
        squares[0] = r;
        for (uint256 i = 1; i < CONST_PROOF_SIZE_LOG_N; ++i) {
            squares[i] = squares[i - 1].sqr();
        }
    }

    // Compute the evaluations  A_l(r^{2^l}) for l = 0, ..., m-1
    function computeFoldPosEvaluations(
        Fr[CONST_PROOF_SIZE_LOG_N] memory sumcheckUChallenges,
        Fr batchedEvalAccumulator,
        Fr[CONST_PROOF_SIZE_LOG_N] memory geminiEvaluations,
        Fr[CONST_PROOF_SIZE_LOG_N] memory geminiEvalChallengePowers,
        uint256 logSize
    ) internal view returns (Fr[CONST_PROOF_SIZE_LOG_N] memory foldPosEvaluations) {
        for (uint256 i = CONST_PROOF_SIZE_LOG_N; i > 0; --i) {
            Fr challengePower = geminiEvalChallengePowers[i - 1];
            Fr u = sumcheckUChallenges[i - 1];

            Fr batchedEvalRoundAcc = (
                (challengePower * batchedEvalAccumulator * Fr.wrap(2))
                    - geminiEvaluations[i - 1] * (challengePower * (Fr.wrap(1) - u) - u)
            );
            // Divide by the denominator
            batchedEvalRoundAcc = batchedEvalRoundAcc * (challengePower * (Fr.wrap(1) - u) + u).invert();

            if (i <= logSize) {
                batchedEvalAccumulator = batchedEvalRoundAcc;
                foldPosEvaluations[i - 1] = batchedEvalRoundAcc;
            }
        }

    }
}

interface IVerifier {
    function verify(bytes calldata _proof, bytes32[] calldata _publicInputs) external view returns (bool);
}


abstract contract BaseHonkVerifier is IVerifier {
    using FrLib for Fr;

    uint256 immutable n;
    uint256 immutable logN;
    uint256 immutable numPublicInputs;

    constructor(uint256 _n, uint256 _logN, uint256 _numPublicInputs) {
        n = _n;
        logN = _logN;
        numPublicInputs = _numPublicInputs;
    }

    error ProofLengthWrong();
    error PublicInputsLengthWrong();
    error SumcheckFailed();
    error ShpleminiFailed();

    // Number of field elements in a ultra honk zero knowledge proof
    uint256 constant PROOF_SIZE = 440;

    function loadVerificationKey() internal pure virtual returns (Honk.VerificationKey memory);

    function verify(bytes calldata proof, bytes32[] calldata publicInputs) public view override returns (bool) {
         // Check the received proof is the expected size where each field element is 32 bytes
        if (proof.length != PROOF_SIZE * 32) {
            revert ProofLengthWrong();
        }

        Honk.VerificationKey memory vk = loadVerificationKey();
        Honk.Proof memory p = TranscriptLib.loadProof(proof);

        if (publicInputs.length != vk.publicInputsSize) {
            revert PublicInputsLengthWrong();
        }

        // Generate the fiat shamir challenges for the whole protocol
        // TODO(https://github.com/AztecProtocol/barretenberg/issues/1281): Add pubInputsOffset to VK or remove entirely.
        Transcript memory t = TranscriptLib.generateTranscript(p, publicInputs, vk.circuitSize, vk.publicInputsSize, /*pubInputsOffset=*/1);

        // Derive public input delta
        // TODO(https://github.com/AztecProtocol/barretenberg/issues/1281): Add pubInputsOffset to VK or remove entirely.
        t.relationParameters.publicInputsDelta = computePublicInputDelta(
            publicInputs, t.relationParameters.beta, t.relationParameters.gamma, /*pubInputsOffset=*/1
        );

        // Sumcheck
        bool sumcheckVerified = verifySumcheck(p, t);
        if (!sumcheckVerified) revert SumcheckFailed();

        bool shpleminiVerified = verifyShplemini(p, vk, t);
        if (!shpleminiVerified) revert ShpleminiFailed();

        return sumcheckVerified && shpleminiVerified; // Boolean condition not required - nice for vanity :)
    }

    function computePublicInputDelta(bytes32[] memory publicInputs, Fr beta, Fr gamma, uint256 offset)
        internal
        view
        returns (Fr publicInputDelta)
    {
        Fr numerator = Fr.wrap(1);
        Fr denominator = Fr.wrap(1);

        Fr numeratorAcc = gamma + (beta * FrLib.from(n + offset));
        Fr denominatorAcc = gamma - (beta * FrLib.from(offset + 1));

        {
            for (uint256 i = 0; i < numPublicInputs; i++) {
                Fr pubInput = FrLib.fromBytes32(publicInputs[i]);

                numerator = numerator * (numeratorAcc + pubInput);
                denominator = denominator * (denominatorAcc + pubInput);

                numeratorAcc = numeratorAcc + beta;
                denominatorAcc = denominatorAcc - beta;
            }
        }

        // Fr delta = numerator / denominator; // TOOO: batch invert later?
        publicInputDelta = FrLib.div(numerator, denominator);
    }

    function verifySumcheck(Honk.Proof memory proof, Transcript memory tp) internal view returns (bool verified) {
        Fr roundTarget;
        Fr powPartialEvaluation = Fr.wrap(1);

        // We perform sumcheck reductions over log n rounds ( the multivariate degree )
        for (uint256 round; round < logN; ++round) {
            Fr[BATCHED_RELATION_PARTIAL_LENGTH] memory roundUnivariate = proof.sumcheckUnivariates[round];
            bool valid = checkSum(roundUnivariate, roundTarget);
            if (!valid) revert SumcheckFailed();

            Fr roundChallenge = tp.sumCheckUChallenges[round];

            // Update the round target for the next rounf
            roundTarget = computeNextTargetSum(roundUnivariate, roundChallenge);
            powPartialEvaluation = partiallyEvaluatePOW(tp.gateChallenges[round], powPartialEvaluation, roundChallenge);
        }

        // Last round
        Fr grandHonkRelationSum =
            RelationsLib.accumulateRelationEvaluations(proof.sumcheckEvaluations, tp.relationParameters, tp.alphas, powPartialEvaluation);
        verified = (grandHonkRelationSum == roundTarget);
    }

    function checkSum(Fr[BATCHED_RELATION_PARTIAL_LENGTH] memory roundUnivariate, Fr roundTarget)
        internal
        pure
        returns (bool checked)
    {
        Fr totalSum = roundUnivariate[0] + roundUnivariate[1];
        checked = totalSum == roundTarget;
    }

    // Return the new target sum for the next sumcheck round
    function computeNextTargetSum(Fr[BATCHED_RELATION_PARTIAL_LENGTH] memory roundUnivariates, Fr roundChallenge)
        internal
        view
        returns (Fr targetSum)
    {
        // TODO: inline
        Fr[BATCHED_RELATION_PARTIAL_LENGTH] memory BARYCENTRIC_LAGRANGE_DENOMINATORS = [
            Fr.wrap(0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffec51),
            Fr.wrap(0x00000000000000000000000000000000000000000000000000000000000002d0),
            Fr.wrap(0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff11),
            Fr.wrap(0x0000000000000000000000000000000000000000000000000000000000000090),
            Fr.wrap(0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff71),
            Fr.wrap(0x00000000000000000000000000000000000000000000000000000000000000f0),
            Fr.wrap(0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593effffd31),
            Fr.wrap(0x00000000000000000000000000000000000000000000000000000000000013b0)
        ];

        // To compute the next target sum, we evaluate the given univariate at a point u (challenge).

        // Performing Barycentric evaluations
        // Compute B(x)
        Fr numeratorValue = Fr.wrap(1);
        for (uint256 i = 0; i < BATCHED_RELATION_PARTIAL_LENGTH; ++i) {
            numeratorValue = numeratorValue * (roundChallenge - Fr.wrap(i));
        }

        // Calculate domain size N of inverses
        Fr[BATCHED_RELATION_PARTIAL_LENGTH] memory denominatorInverses;
        for (uint256 i = 0; i < BATCHED_RELATION_PARTIAL_LENGTH; ++i) {
            Fr inv = BARYCENTRIC_LAGRANGE_DENOMINATORS[i];
            inv = inv * (roundChallenge - Fr.wrap(i));
            inv = FrLib.invert(inv);
            denominatorInverses[i] = inv;
        }

        for (uint256 i = 0; i < BATCHED_RELATION_PARTIAL_LENGTH; ++i) {
            Fr term = roundUnivariates[i];
            term = term * denominatorInverses[i];
            targetSum = targetSum + term;
        }

        // Scale the sum by the value of B(x)
        targetSum = targetSum * numeratorValue;
    }

    // Univariate evaluation of the monomial ((1-X_l) + X_l.B_l) at the challenge point X_l=u_l
    function partiallyEvaluatePOW(Fr gateChallenge, Fr currentEvaluation, Fr roundChallenge)
        internal
        pure
        returns (Fr newEvaluation)
    {
        Fr univariateEval = Fr.wrap(1) + (roundChallenge * (gateChallenge - Fr.wrap(1)));
        newEvaluation = currentEvaluation * univariateEval;
    }

    function verifyShplemini(Honk.Proof memory proof, Honk.VerificationKey memory vk, Transcript memory tp)
        internal
        view
        returns (bool verified)
    {
        ShpleminiIntermediates memory mem; // stack

        // - Compute vector (r, r², ... , r²⁽ⁿ⁻¹⁾), where n = log_circuit_size
        Fr[CONST_PROOF_SIZE_LOG_N] memory powers_of_evaluation_challenge = CommitmentSchemeLib.computeSquares(tp.geminiR);

        // Arrays hold values that will be linearly combined for the gemini and shplonk batch openings
        Fr[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2] memory scalars;
        Honk.G1Point[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2] memory commitments;

        mem.posInvertedDenominator = (tp.shplonkZ - powers_of_evaluation_challenge[0]).invert();
        mem.negInvertedDenominator = (tp.shplonkZ + powers_of_evaluation_challenge[0]).invert();

        mem.unshiftedScalar = mem.posInvertedDenominator + (tp.shplonkNu * mem.negInvertedDenominator);
        mem.shiftedScalar =
            tp.geminiR.invert() * (mem.posInvertedDenominator - (tp.shplonkNu * mem.negInvertedDenominator));

        scalars[0] = Fr.wrap(1);
        commitments[0] = convertProofPoint(proof.shplonkQ);

        mem.batchingChallenge = Fr.wrap(1);
        mem.batchedEvaluation = Fr.wrap(0);

        for (uint256 i = 1; i <= NUMBER_UNSHIFTED; ++i) {
            scalars[i] = mem.unshiftedScalar.neg() * mem.batchingChallenge;
            mem.batchedEvaluation = mem.batchedEvaluation + (proof.sumcheckEvaluations[i - 1] * mem.batchingChallenge);
            mem.batchingChallenge = mem.batchingChallenge * tp.rho;
        }
        // g commitments are accumulated at r
        for (uint256 i = NUMBER_UNSHIFTED + 1; i <= NUMBER_OF_ENTITIES; ++i) {
            scalars[i] = mem.shiftedScalar.neg() * mem.batchingChallenge;
            mem.batchedEvaluation = mem.batchedEvaluation + (proof.sumcheckEvaluations[i - 1] * mem.batchingChallenge);
            mem.batchingChallenge = mem.batchingChallenge * tp.rho;
        }

        commitments[1] = vk.qm;
        commitments[2] = vk.qc;
        commitments[3] = vk.ql;
        commitments[4] = vk.qr;
        commitments[5] = vk.qo;
        commitments[6] = vk.q4;
        commitments[7] = vk.qLookup;
        commitments[8] = vk.qArith;
        commitments[9] = vk.qDeltaRange;
        commitments[10] = vk.qElliptic;
        commitments[11] = vk.qAux;
        commitments[12] = vk.qPoseidon2External;
        commitments[13] = vk.qPoseidon2Internal;
        commitments[14] = vk.s1;
        commitments[15] = vk.s2;
        commitments[16] = vk.s3;
        commitments[17] = vk.s4;
        commitments[18] = vk.id1;
        commitments[19] = vk.id2;
        commitments[20] = vk.id3;
        commitments[21] = vk.id4;
        commitments[22] = vk.t1;
        commitments[23] = vk.t2;
        commitments[24] = vk.t3;
        commitments[25] = vk.t4;
        commitments[26] = vk.lagrangeFirst;
        commitments[27] = vk.lagrangeLast;

        // Accumulate proof points
        commitments[28] = convertProofPoint(proof.w1);
        commitments[29] = convertProofPoint(proof.w2);
        commitments[30] = convertProofPoint(proof.w3);
        commitments[31] = convertProofPoint(proof.w4);
        commitments[32] = convertProofPoint(proof.zPerm);
        commitments[33] = convertProofPoint(proof.lookupInverses);
        commitments[34] = convertProofPoint(proof.lookupReadCounts);
        commitments[35] = convertProofPoint(proof.lookupReadTags);

        // to be Shifted
        commitments[36] = convertProofPoint(proof.w1);
        commitments[37] = convertProofPoint(proof.w2);
        commitments[38] = convertProofPoint(proof.w3);
        commitments[39] = convertProofPoint(proof.w4);
        commitments[40] = convertProofPoint(proof.zPerm);

        // Add contributions from A₀(r) and A₀(-r) to constant_term_accumulator:
        // Compute the evaluations A_l(r^{2^l}) for l = 0, ..., logN - 1
        Fr[CONST_PROOF_SIZE_LOG_N] memory foldPosEvaluations = CommitmentSchemeLib.computeFoldPosEvaluations(
            tp.sumCheckUChallenges,
            mem.batchedEvaluation,
            proof.geminiAEvaluations,
            powers_of_evaluation_challenge,
            logN
        );

        // Compute the Shplonk constant term contributions from A₀(±r)
        mem.constantTermAccumulator = foldPosEvaluations[0] * mem.posInvertedDenominator;
        mem.constantTermAccumulator =
            mem.constantTermAccumulator + (proof.geminiAEvaluations[0] * tp.shplonkNu * mem.negInvertedDenominator);
        mem.batchingChallenge = tp.shplonkNu.sqr();

        // Compute Shplonk constant term contributions from Aₗ(±r^{2ˡ}) for l = 1, ..., m-1;
        // Compute scalar multipliers for each fold commitment
        for (uint256 i = 0; i < CONST_PROOF_SIZE_LOG_N - 1; ++i) {
            bool dummy_round = i >= (logN - 1);

            if (!dummy_round) {
                // Update inverted denominators
                mem.posInvertedDenominator = (tp.shplonkZ - powers_of_evaluation_challenge[i + 1]).invert();
                mem.negInvertedDenominator = (tp.shplonkZ + powers_of_evaluation_challenge[i + 1]).invert();

                // Compute the scalar multipliers for Aₗ(± r^{2ˡ}) and [Aₗ]
                mem.scalingFactorPos = mem.batchingChallenge * mem.posInvertedDenominator;
                mem.scalingFactorNeg = mem.batchingChallenge * tp.shplonkNu * mem.negInvertedDenominator;
                // [Aₗ] is multiplied by -v^{2l}/(z-r^{2^l}) - v^{2l+1} /(z+ r^{2^l})
                scalars[NUMBER_OF_ENTITIES + 1 + i] = mem.scalingFactorNeg.neg() + mem.scalingFactorPos.neg();

                // Accumulate the const term contribution given by
                // v^{2l} * Aₗ(r^{2ˡ}) /(z-r^{2^l}) + v^{2l+1} * Aₗ(-r^{2ˡ}) /(z+ r^{2^l})
                Fr accumContribution = mem.scalingFactorNeg * proof.geminiAEvaluations[i + 1];
                accumContribution = accumContribution + mem.scalingFactorPos * foldPosEvaluations[i + 1];
                mem.constantTermAccumulator = mem.constantTermAccumulator + accumContribution;
                // Update the running power of v
                mem.batchingChallenge = mem.batchingChallenge * tp.shplonkNu * tp.shplonkNu;
            }

            commitments[NUMBER_OF_ENTITIES + 1 + i] = convertProofPoint(proof.geminiFoldComms[i]);
        }

        // Finalise the batch opening claim
        commitments[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N] = Honk.G1Point({x: 1, y: 2});
        scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N] = mem.constantTermAccumulator;

        Honk.G1Point memory quotient_commitment = convertProofPoint(proof.kzgQuotient);

        commitments[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 1] = quotient_commitment;
        scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 1] = tp.shplonkZ; // evaluation challenge

        Honk.G1Point memory P_0 = batchMul(commitments, scalars);
        Honk.G1Point memory P_1 = negateInplace(quotient_commitment);

        return pairing(P_0, P_1);
    }

    // This implementation is the same as above with different constants
    function batchMul(
        Honk.G1Point[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2] memory base,
        Fr[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2] memory scalars
    ) internal view returns (Honk.G1Point memory result) {
        uint256 limit = NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2;
        assembly {
            let success := 0x01
            let free := mload(0x40)

            // Write the original into the accumulator
            // Load into memory for ecMUL, leave offset for eccAdd result
            // base is an array of pointers, so we have to dereference them
            mstore(add(free, 0x40), mload(mload(base)))
            mstore(add(free, 0x60), mload(add(0x20, mload(base))))
            // Add scalar
            mstore(add(free, 0x80), mload(scalars))
            success := and(success, staticcall(gas(), 7, add(free, 0x40), 0x60, free, 0x40))

            let count := 0x01
            for {} lt(count, limit) { count := add(count, 1) } {
                // Get loop offsets
                let base_base := add(base, mul(count, 0x20))
                let scalar_base := add(scalars, mul(count, 0x20))

                mstore(add(free, 0x40), mload(mload(base_base)))
                mstore(add(free, 0x60), mload(add(0x20, mload(base_base))))
                // Add scalar
                mstore(add(free, 0x80), mload(scalar_base))

                success := and(success, staticcall(gas(), 7, add(free, 0x40), 0x60, add(free, 0x40), 0x40))
                // accumulator = accumulator + accumulator_2
                success := and(success, staticcall(gas(), 6, free, 0x80, free, 0x40))
            }

            // Return the result - i hate this
            mstore(result, mload(free))
            mstore(add(result, 0x20), mload(add(free, 0x20)))
        }
    }
}

contract HonkVerifier is BaseHonkVerifier(N, LOG_N, NUMBER_OF_PUBLIC_INPUTS) {
     function loadVerificationKey() internal pure override returns (Honk.VerificationKey memory) {
       return HonkVerificationKey.loadVerificationKey();
    }
}


// File contracts/Voting.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;


/// Checkpoint 6 //////

contract Voting is Ownable {
    using LeanIMT for LeanIMTData;

    //////////////////
    /// Errors //////
    /////////////////

    error Voting__CommitmentAlreadyAdded(uint256 commitment);
    error Voting__NullifierHashAlreadyUsed(bytes32 nullifierHash);
    error Voting__InvalidProof();
    error Voting__NotAllowedToVote();
    error Voting__EmptyTree();
    error Voting__InvalidRoot();

    ///////////////////////
    /// State Variables ///
    ///////////////////////

    string private s_question;
    mapping(address => bool) private s_voters;
    uint256 private s_yesVotes;
    uint256 private s_noVotes;

    /// Checkpoint 2 //////
    mapping(address => bool) private s_hasRegistered;
    mapping(uint256 => bool) private s_commitments;

    LeanIMTData private s_tree;

    /// Checkpoint 6 //////
    IVerifier public immutable i_verifier;
    mapping(bytes32 => bool) private s_nullifierHashes;

    //////////////
    /// Events ///
    //////////////

    event VoterAdded(address indexed voter);
    event NewLeaf(uint256 index, uint256 value);
    event VoteCast(
        bytes32 indexed nullifierHash,
        address indexed voter,
        bool vote,
        uint256 timestamp,
        uint256 totalYes,
        uint256 totalNo
    );

    //////////////////
    ////Constructor///
    //////////////////

    constructor(address _owner, address _verifier, string memory _question) Ownable(_owner) {
        s_question = _question;
        /// Checkpoint 6 //////
        i_verifier = IVerifier(_verifier);
    }

    //////////////////
    /// Functions ///
    //////////////////

    /**
     * @notice Batch updates the allowlist of voter EOAs
     * @dev Only the contract owner can call this function. Emits `VoterAdded` for each updated entry.
     * @param voters Addresses to update in the allowlist
     * @param statuses True to allow, false to revoke
     */
    function addVoters(address[] calldata voters, bool[] calldata statuses) public onlyOwner {
        require(voters.length == statuses.length, "Voters and statuses length mismatch");

        for (uint256 i = 0; i < voters.length; i++) {
            s_voters[voters[i]] = statuses[i];
            emit VoterAdded(voters[i]);
        }
    }

    /**
     * @notice Registers a commitment leaf for an allowlisted address
     * @dev A given allowlisted address can register exactly once. Reverts if
     *      the caller is not allowlisted or has already registered, or if the
     *      same commitment has been previously inserted. Emits `NewLeaf`.
     * @param _commitment The Poseidon-based commitment to insert into the IMT
     */
    function register(uint256 _commitment) public {
        /// Checkpoint 2 //////

        if (!s_voters[msg.sender] || s_hasRegistered[msg.sender]) {
            revert Voting__NotAllowedToVote();
        }
        if (s_commitments[_commitment]) {
            revert Voting__CommitmentAlreadyAdded(_commitment);
        }
        s_commitments[_commitment] = true;
        s_hasRegistered[msg.sender] = true;
        s_tree.insert(_commitment);
        emit NewLeaf(s_tree.size - 1, _commitment);
    }

    /**
     * @notice Casts a vote using a zero-knowledge proof
     * @dev Enforces single-use via `s_nullifierHashes`. Public inputs order must
     *      match the circuit: root, nullifierHash, vote, depth. The `_vote`
     *      value is interpreted as: 1 => yes, any other value => no. Emits `VoteCast`.
     * @param _proof Ultra Honk proof bytes
     * @param _root Merkle root corresponding to the registered commitments tree
     * @param _nullifierHash Unique nullifier to prevent double voting
     * @param _vote Encoded vote: 1 for yes, otherwise counted as no
     * @param _depth Tree depth used by the circuit
     */
    function vote(bytes memory _proof, bytes32 _nullifierHash, bytes32 _root, bytes32 _vote, bytes32 _depth) public {
        /// Checkpoint 6 //////
	    if (_root == bytes32(0)) {
            revert Voting__EmptyTree();
        }

        if (_root != bytes32(s_tree.root())) {
            revert Voting__InvalidRoot();
        }

        bytes32[] memory publicInputs = new bytes32[](4);
        publicInputs[0] = _nullifierHash;
        publicInputs[1] = _root;
        publicInputs[2] = _vote;
        publicInputs[3] = _depth;

        if (!i_verifier.verify(_proof, publicInputs)) {
            revert Voting__InvalidProof();
        }

        if (s_nullifierHashes[_nullifierHash]) {
            revert Voting__NullifierHashAlreadyUsed(_nullifierHash);
        }
        s_nullifierHashes[_nullifierHash] = true;

        if (_vote == bytes32(uint256(1))) {
            s_yesVotes++;
        } else {
            s_noVotes++;
        }

        emit VoteCast(_nullifierHash, msg.sender, _vote == bytes32(uint256(1)), block.timestamp, s_yesVotes, s_noVotes);
    }

    /////////////////////////
    /// Getter Functions ///
    ////////////////////////

    function getVotingData()
        public
        view
        returns (
            string memory question,
            address contractOwner,
            uint256 yesVotes,
            uint256 noVotes,
            uint256 size,
            uint256 depth,
            uint256 root
        )
    {
        question = s_question;
        contractOwner = owner();
        yesVotes = s_yesVotes;
        noVotes = s_noVotes;
        /// Checkpoint 2 //////
        size = s_tree.size;
        depth = s_tree.depth;
        root = s_tree.root();
    }

    function getVoterData(address _voter) public view returns (bool voter, bool registered) {
        voter = s_voters[_voter];
        // /// Checkpoint 2 //////
        registered = s_hasRegistered[_voter];
    }
}
