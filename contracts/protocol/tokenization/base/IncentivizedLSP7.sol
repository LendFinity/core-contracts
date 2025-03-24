// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {Context} from '../../../dependencies/openzeppelin/contracts/Context.sol';
import {SafeCast} from '../../../dependencies/openzeppelin/contracts/SafeCast.sol';
import {WadRayMath} from '../../libraries/math/WadRayMath.sol';
import {Errors} from '../../libraries/helpers/Errors.sol';
import {IAaveIncentivesController} from '../../../interfaces/IAaveIncentivesController.sol';
import {IPoolAddressesProvider} from '../../../interfaces/IPoolAddressesProvider.sol';
import {IPool} from '../../../interfaces/IPool.sol';
import {IACLManager} from '../../../interfaces/IACLManager.sol';

import '@lukso/lsp7-contracts/contracts/LSP7DigitalAsset.sol';

/**
 * @title IncentivizedLSP7
 * @author Lendfinity, inspired by Aave and LUKSO LSP7 implementation
 * @notice Basic LSP7 implementation with incentives
 * @dev This implements the LUKSO LSP7 Digital Asset Standard (ERC20 equivalent)
 */
contract IncentivizedLSP7 is Context, ILSP7DigitalAsset {
  using WadRayMath for uint256;
  using SafeCast for uint256;

  // --- Events ---

  /**
   * @dev Emitted when `tokenOwner` enables `operator` to transfer or burn `amount` of tokens.
   * @param operator The address authorized as an operator
   * @param tokenOwner The token owner
   * @param amount The amount of tokens `operator` is authorized to transfer or burn
   * @param operatorNotificationData Additional data attached to the authorization
   */
  event AuthorizedOperator(
    address indexed operator,
    address indexed tokenOwner,
    uint256 amount,
    bytes operatorNotificationData
  );

  /**
   * @dev Emitted when `tokenOwner` disables `operator` from transferring or burning tokens.
   * @param operator The address revoked from the operator role
   * @param tokenOwner The token owner
   * @param operatorNotificationData Additional data attached to the revocation
   */
  event RevokedOperator(
    address indexed operator,
    address indexed tokenOwner,
    bytes operatorNotificationData
  );

  /**
   * @dev Only pool admin can call functions marked by this modifier.
   */
  modifier onlyPoolAdmin() {
    IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
    require(aclManager.isPoolAdmin(msg.sender), Errors.CALLER_NOT_POOL_ADMIN);
    _;
  }

  /**
   * @dev Only pool can call functions marked by this modifier.
   */
  modifier onlyPool() {
    require(_msgSender() == address(POOL), Errors.CALLER_MUST_BE_POOL);
    _;
  }

  /**
   * @dev UserState - additionalData is a flexible field.
   * Similar to ERC20 implementation but adapted for LSP7
   */
  struct UserState {
    uint128 balance;
    uint128 additionalData;
  }
  // Map of users address and their state data (userAddress => userStateData)
  mapping(address => UserState) internal _userState;

  // Map of authorizations (tokenOwner => operator => amount)
  mapping(address => mapping(address => uint256)) private _operatorAuthorizations;

  uint256 internal _totalSupply;
  string private _name;
  string private _symbol;
  uint8 private _decimals;

  // True if all transfers need operator authorization
  bool private _isOperatorFilteringEnabled;

  IAaveIncentivesController internal _incentivesController;
  IPoolAddressesProvider internal immutable _addressesProvider;
  IPool public immutable POOL;

  /**
   * @dev Constructor.
   * @param pool The reference to the main Pool contract
   * @param name The name of the token
   * @param symbol The symbol of the token
   * @param decimals The number of decimals of the token
   * @param isOperatorFilteringEnabled Whether to enable operator filtering
   */
  constructor(
    IPool pool,
    string memory name,
    string memory symbol,
    uint8 decimals,
    bool isOperatorFilteringEnabled
  ) {
    _addressesProvider = pool.ADDRESSES_PROVIDER();
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
    _isOperatorFilteringEnabled = isOperatorFilteringEnabled;
    POOL = pool;
  }

  /**
   * @notice Returns the name of the token
   * @return The name of the token
   */
  function name() public view returns (string memory) {
    return _name;
  }

  /**
   * @notice Returns the symbol of the token
   * @return The symbol of the token
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
   * @notice Returns the decimals of the token
   * @return The decimals of the token
   */
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  /**
   * @notice Returns the total supply of the token
   * @return The total supply of the token
   */
  function totalSupply() public view virtual returns (uint256) {
    return _totalSupply;
  }

  /**
   * @notice Returns the balance of the account
   * @param tokenOwner The address whose balance is queried
   * @return The balance of the account
   */
  function balanceOf(address tokenOwner) public view virtual returns (uint256) {
    return _userState[tokenOwner].balance;
  }

  /**
   * @notice Returns the address of the Incentives Controller contract
   * @return The address of the Incentives Controller
   */
  function getIncentivesController() external view virtual returns (IAaveIncentivesController) {
    return _incentivesController;
  }

  /**
   * @notice Sets a new Incentives Controller
   * @param controller the new Incentives controller
   */
  function setIncentivesController(IAaveIncentivesController controller) external onlyPoolAdmin {
    _incentivesController = controller;
  }

  /**
   * @notice Returns whether operator filtering is enabled for this token
   * @return True if operator filtering is enabled
   */
  function isOperatorFilteringEnabled() public view returns (bool) {
    return _isOperatorFilteringEnabled;
  }

  /**
   * @notice Returns the amount of tokens the operator is authorized to transfer
   * @param operator The address of the operator
   * @param tokenOwner The address of the token owner
   * @return The amount the operator is authorized to transfer
   */
  function authorizedAmountFor(address operator, address tokenOwner) public view returns (uint256) {
    return _operatorAuthorizations[tokenOwner][operator];
  }

  /**
   * @notice Authorizes an operator to transfer tokens on behalf of the caller
   * @param operator The address to authorize
   * @param amount The amount of tokens to authorize
   * @param operatorNotificationData Additional data to notify operator
   */
  function authorizeOperator(
    address operator,
    uint256 amount,
    bytes memory operatorNotificationData
  ) public virtual {
    require(operator != address(0), 'LSP7: operator cannot be zero address');
    _operatorAuthorizations[_msgSender()][operator] = amount;
    emit OperatorAuthorizationChanged(operator, _msgSender(), amount, operatorNotificationData);
  }

  /**
   * @notice Revokes operator authorization for tokens
   * @param operator The address to revoke authorization from
   * @param tokenOwner The address of the token owner
   * @param notify Whether to notify the operator
   * @param operatorNotificationData Additional data to notify operator
   */
  function revokeOperator(
    address operator,
    address tokenOwner,
    bool notify,
    bytes memory operatorNotificationData
  ) public virtual {
    require(
      _msgSender() == operator || _msgSender() == tokenOwner,
      'LSP7: caller must be operator or token owner'
    );
    require(operator != address(0), 'LSP7: operator cannot be zero address');

    delete _operatorAuthorizations[tokenOwner][operator];
    emit OperatorRevoked(operator, tokenOwner, notify, operatorNotificationData);
  }

  /**
   * @notice Revokes operator authorization for all tokens
   * @param operator The address to revoke authorization from
   * @param operatorNotificationData Additional data to notify operator
   */
  function revokeOperator(address operator, bytes memory operatorNotificationData) public virtual {
    revokeOperator(operator, _msgSender(), true, operatorNotificationData);
  }

  /**
   * @notice Transfers tokens from the caller to the recipient
   * @param to The address of the recipient
   * @param amount The amount of tokens to transfer
   * @param tokenHolderData Additional data for token holder
   * @param operatorNotificationData Additional data for operators
   */
  function transferLSP7(
    address to,
    uint256 amount,
    bytes memory tokenHolderData,
    bytes memory operatorNotificationData
  ) public virtual {
    _transfer(
      _msgSender(),
      _msgSender(),
      to,
      amount.toUint128(),
      tokenHolderData,
      operatorNotificationData
    );
  }

  /**
   * @notice Transfers tokens on behalf of the token owner
   * @param from The address of the token owner
   * @param to The address of the recipient
   * @param amount The amount of tokens to transfer
   * @param tokenHolderData Additional data for token holder
   * @param operatorNotificationData Additional data for operators
   */
  function transferFrom(
    address from,
    address to,
    uint256 amount,
    bytes memory tokenHolderData,
    bytes memory operatorNotificationData
  ) public virtual {
    uint128 castAmount = amount.toUint128();

    if (_isOperatorFilteringEnabled && _msgSender() != from) {
      uint256 authorizedAmount = _operatorAuthorizations[from][_msgSender()];
      require(authorizedAmount >= castAmount, 'LSP7: not authorized amount');

      // Reduce the authorized amount
      _operatorAuthorizations[from][_msgSender()] = authorizedAmount - castAmount;
    }

    _transfer(_msgSender(), from, to, castAmount, tokenHolderData, operatorNotificationData);
  }

  /**
   * @notice Transfers tokens between two users and apply incentives if defined
   * @param operator The operator executing the transfer
   * @param from The source address
   * @param to The destination address
   * @param amount The amount getting transferred
   * @param tokenHolderData Additional data for token holder
   * @param operatorNotificationData Additional data for operators
   */
  function _transfer(
    address operator,
    address from,
    address to,
    uint128 amount,
    bytes memory tokenHolderData,
    bytes memory operatorNotificationData
  ) internal virtual {
    require(from != address(0), 'LSP7: transfer from zero address');
    require(to != address(0), 'LSP7: transfer to zero address');

    uint128 oldSenderBalance = _userState[from].balance;
    require(oldSenderBalance >= amount, 'LSP7: insufficient balance');

    _userState[from].balance = oldSenderBalance - amount;
    uint128 oldRecipientBalance = _userState[to].balance;
    _userState[to].balance = oldRecipientBalance + amount;

    // Handle incentives if controller is set
    IAaveIncentivesController incentivesControllerLocal = _incentivesController;
    if (address(incentivesControllerLocal) != address(0)) {
      uint256 currentTotalSupply = _totalSupply;
      incentivesControllerLocal.handleAction(from, currentTotalSupply, oldSenderBalance);
      if (from != to) {
        incentivesControllerLocal.handleAction(to, currentTotalSupply, oldRecipientBalance);
      }
    }

    emit Transfer(operator, from, to, amount, false, tokenHolderData);
  }

  /**
   * @notice Update the name of the token
   * @param newName The new name for the token
   */
  function _setName(string memory newName) internal {
    _name = newName;
  }

  /**
   * @notice Update the symbol for the token
   * @param newSymbol The new symbol for the token
   */
  function _setSymbol(string memory newSymbol) internal {
    _symbol = newSymbol;
  }

  /**
   * @notice Update the number of decimals for the token
   * @param newDecimals The new number of decimals for the token
   */
  function _setDecimals(uint8 newDecimals) internal {
    _decimals = newDecimals;
  }

  /**
   * @notice Returns the operators for a token owner
   * @param tokenOwner The address of the token owner
   * @return A list of operators for the tokenOwner
   */
  function getOperatorsOf(address tokenOwner) external view returns (address[] memory) {
    // Return an empty array instead of reverting
    return new address[](0);
  }

  /**
   * @notice Implementation of supportsInterface according to ERC-165
   * @param interfaceId The interface identifier to check
   * @return True if the contract supports the interface
   */
  function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
    return interfaceId == type(ILSP7DigitalAsset).interfaceId || interfaceId == 0x01ffc9a7; // ERC165 Interface ID
  }

  /**
   * @notice Transfer a token between addresses while the operator covers the gas cost
   * @param from The sending address
   * @param to The receiving address
   * @param amount The amount of tokens to transfer
   * @param force When set to TRUE, the transfer will be successful even if recipient is a contract that doesn't implement LSP1 interface
   * @param data Additional data the caller wants included in the emitted event, and sent in the hooks to `from` and `to` addresses
   */
  function transfer(
    address from,
    address to,
    uint256 amount,
    bool force,
    bytes memory data
  ) public virtual {
    require(from != address(0), 'LSP7: transfer from zero address');
    require(to != address(0), 'LSP7: transfer to zero address');
    require(from != to, 'LSP7: transfer to self');

    // Check authorization if sender is not the token owner
    if (_msgSender() != from && _isOperatorFilteringEnabled) {
      uint256 authorizedAmount = _operatorAuthorizations[from][_msgSender()];
      require(authorizedAmount >= amount, 'LSP7: not authorized amount');

      // Reduce the authorized amount
      _operatorAuthorizations[from][_msgSender()] = authorizedAmount - amount;
    }

    uint128 castAmount = amount.toUint128();
    uint128 oldSenderBalance = _userState[from].balance;
    require(oldSenderBalance >= castAmount, 'LSP7: insufficient balance');

    _userState[from].balance = oldSenderBalance - castAmount;
    uint128 oldRecipientBalance = _userState[to].balance;
    _userState[to].balance = oldRecipientBalance + castAmount;

    // Handle incentives if controller is set
    IAaveIncentivesController incentivesControllerLocal = _incentivesController;
    if (address(incentivesControllerLocal) != address(0)) {
      uint256 currentTotalSupply = _totalSupply;
      incentivesControllerLocal.handleAction(from, currentTotalSupply, oldSenderBalance);
      if (from != to) {
        incentivesControllerLocal.handleAction(to, currentTotalSupply, oldRecipientBalance);
      }
    }

    emit Transfer(_msgSender(), from, to, amount, force, data);
  }

  /**
   * @notice Batch transfer tokens to multiple addresses with data and force parameters
   * @param from Array of sending addresses
   * @param to Array of receiving addresses
   * @param amount Array of amounts to transfer
   * @param force Array of force parameters
   * @param data Array of data parameters
   */
  function transferBatch(
    address[] memory from,
    address[] memory to,
    uint256[] memory amount,
    bool[] memory force,
    bytes[] memory data
  ) external virtual {
    require(
      from.length == to.length &&
        to.length == amount.length &&
        amount.length == force.length &&
        force.length == data.length,
      'LSP7: Array lengths mismatch'
    );

    for (uint256 i = 0; i < from.length; i++) {
      // We need to check if the caller is the token owner or an authorized operator
      if (_msgSender() == from[i]) {
        // Direct transfer by token owner
        transfer(from[i], to[i], amount[i], force[i], data[i]);
      } else {
        // Transfer by operator
        transfer(from[i], to[i], amount[i], force[i], data[i]);
      }
    }
  }

  /**
   * @notice Batch execute calls to the contract
   * @param data Array of call data to execute
   * @return results Array of results from the calls
   */
  function batchCalls(bytes[] calldata data) external returns (bytes[] memory results) {
    results = new bytes[](data.length);
    for (uint256 i = 0; i < data.length; i++) {
      (bool success, bytes memory result) = address(this).delegatecall(data[i]);
      require(success, 'LSP7: Batch call failed');
      results[i] = result;
    }
    return results;
  }

  /**
   * @notice Increase operator allowance
   * @param operator The operator address
   * @param addedAmount The amount to add to the allowance
   * @param operatorNotificationData Data for operator notification
   */
  function increaseAllowance(
    address operator,
    uint256 addedAmount,
    bytes memory operatorNotificationData
  ) external virtual {
    require(operator != address(0), 'LSP7: operator cannot be zero address');
    _operatorAuthorizations[_msgSender()][operator] += addedAmount;
    emit AuthorizedOperator(
      operator,
      _msgSender(),
      _operatorAuthorizations[_msgSender()][operator],
      operatorNotificationData
    );
  }

  /**
   * @notice Decrease operator allowance
   * @param operator The operator address
   * @param tokenOwner The token owner address
   * @param subtractedAmount The amount to subtract from the allowance
   * @param operatorNotificationData Data for operator notification
   */
  function decreaseAllowance(
    address operator,
    address tokenOwner,
    uint256 subtractedAmount,
    bytes memory operatorNotificationData
  ) external virtual {
    require(_msgSender() == tokenOwner, 'LSP7: caller is not token owner');
    require(operator != address(0), 'LSP7: operator cannot be zero address');

    uint256 currentAllowance = _operatorAuthorizations[tokenOwner][operator];
    require(currentAllowance >= subtractedAmount, 'LSP7: decreased allowance below zero');

    _operatorAuthorizations[tokenOwner][operator] = currentAllowance - subtractedAmount;
    emit AuthorizedOperator(
      operator,
      tokenOwner,
      _operatorAuthorizations[tokenOwner][operator],
      operatorNotificationData
    );
  }

  /**
   * @notice Determines who is the owner of a given token
   * @param tokenId The token ID (not used for fungible tokens)
   * @return The owner of the token
   */
  function tokenOwnerOf(uint256 tokenId) public view virtual returns (address) {
    // For fungible tokens, return zero address instead of reverting
    return address(0);
  }

  /**
   * @notice Get data for the LSP7 contract
   * @param dataKeys The keys to retrieve data for
   * @return The data values for each key
   */
  function getData(bytes32[] memory dataKeys) public view virtual returns (bytes[] memory) {
    // Basic implementation - can be extended with actual data storage
    bytes[] memory dataValues = new bytes[](dataKeys.length);
    return dataValues;
  }

  /**
   * @notice Set data for the LSP7 contract
   * @param dataKeys The keys to set data for
   * @param dataValues The values to set
   */
  function setData(bytes32[] memory dataKeys, bytes[] memory dataValues) public virtual {
    // Just do nothing instead of reverting, since this is not expected to be used
    if (_msgSender() != address(this)) {
      return;
    }
  }

  /**
   * @dev This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
   */
  uint256[50] private __gap;
}
