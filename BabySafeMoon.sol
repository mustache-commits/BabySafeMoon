pragma solidity ^0.8.6;
// SPDX-License-Identifier: MIT

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IFactory{
        function createPair(address tokenA, address tokenB) external returns (address pair);
        function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline) external; 
}
interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BabySafeMoon is Context, Ownable, IERC20 {
    using Address for address;
    using SafeMath for uint256;

    address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
    
    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    
    mapping(address => uint256) private _firstSell;
    mapping(address => uint256) private _totSells;
    
    mapping(address => bool) private _isBot;

    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private _isExcluded;
    address[] private _excluded;
   
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 100000000 * 10**9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private _name = "BabySafeMoon";
    string private _symbol = "BSM";
    uint8 private _decimals = 9;
    
    uint256 public _taxFee = 500;
    uint256 public _devFee = 100;
    uint256 public _marketingFee = 100;
    uint256 public _giveawaysFee = 100;
    uint256 public _iBNBPoolFee = 20;
    uint256 public _swapFee = _devFee.add(_marketingFee).add(_giveawaysFee).add(_iBNBPoolFee);
    uint256 public totFees = 13;

    
    //sell taxes
    uint256 public _sellTaxFee = 500;
    uint256 public _sellDevFee = 100;
    uint256 public _sellMarketingFee = 100;
    uint256 public _sellGiveawaysFee = 100;
    uint256 public _sellIBNBPoolFee = 20;
    uint256 public totSellFees = 13;
    
    uint256 private _previousTaxFee;
    uint256 private _previousDevFee;
    uint256 private _previousMarketingFee;
    uint256 private _previousGiveawaysFee;
    uint256 private _previousIBNBPoolFee;
    uint256 private _previousSwapFee;
    uint256 private previousTotFees;
    
    uint256 public maxSellPerDay = _tTotal.div(1000);
    
    address public marketingWallet = 0x76FdF77F062A85eFd9AFc166A0f47c6CAf21F65B;
    address public devWallet = 0xd87F855A3F595cEAe2e5DA7CB51998b4Be90Ba35;
    address public giveawaysWallet;
    address public iBNBPool = 0x830F7A104a3dF30879D526031D57DAa44BF85686;

    IRouter public pancakeRouter;
    address public pancakePair;
    
    bool inSwap;
    bool public tradingEnabled = false;
    bool public swapEnabled = false;
    uint256 private minTokensToSwap = 50000 * 10**9;
    uint256 public maxTxAmount = _tTotal.mul(1).div(100);

    event swapEnabledUpdated(bool enabled);
    
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
    
    constructor () {
        _rOwned[_msgSender()] = _rTotal;

        IRouter _pancakeRouter = IRouter(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
         // Create a uniswap pair for this new token
        pancakePair = IFactory(_pancakeRouter.factory())
            .createPair(address(this), _pancakeRouter.WETH());

        // set the rest of the contract variables
        pancakeRouter = _pancakeRouter;
        
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[marketingWallet] = true;
        _isExcludedFromFee[devWallet] = true;
        _isExcludedFromFee[giveawaysWallet] = true;
        _isExcludedFromFee[iBNBPool] = true;
        _isExcludedFromFee[address(this)] = true;
        
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFeesCharged() public view returns (uint256) {
        return _tFeeTotal;
    }

    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner() {
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is already excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }
    
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }
    
    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    
     //to recieve ETH from pancakeRouter when swaping
    receive() external payable {}

     function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal     = _rTotal.sub(rFee);
        _tFeeTotal  = _tFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tSwap) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tSwap, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tSwap);
    }

    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tSwap = calculateSwapFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tSwap);
        return (tTransferAmount, tFee, tSwap);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tSwap, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rSwap = tSwap.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rSwap);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
    
    function _takeSwapFees(uint256 tSwap) private {
        uint256 currentRate =  _getRate();
        uint256 rSwap = tSwap.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rSwap);
        if(_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tSwap);
    }

	function _burnTokens(uint256 tBurn) private {
	  uint256 currentRate =  _getRate();
        uint256 rBurn = tBurn.mul(currentRate);
        _rOwned[deadAddress] = _rOwned[deadAddress].add(rBurn);
        if(_isExcluded[deadAddress])
            _tOwned[deadAddress] = _tOwned[deadAddress].add(tBurn);
    }
    
    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        uint256 taxFee = totFees.mul(_taxFee).div(100);
        return _amount.mul(taxFee).div(100);
    }

    function calculateSwapFee(uint256 _amount) private view returns (uint256) {
        uint256 swapFee = totFees.mul(_swapFee).div(100);
        return _amount.mul(swapFee).div(100);
    }
    
    
            //////////////////////////
           /// Setters functions  ///
          //////////////////////////
   function prepareForPresale(address routerDxSale, address contractDxSale) external onlyOwner{
        totFees = 0;
        _swapFee = 0;
        maxTxAmount = _tTotal;
        _isExcludedFromFee[routerDxSale] = true;
        _isExcludedFromFee[contractDxSale] = true;
   }
   
   function afterPresale() external onlyOwner{
        totFees = 100;
        _swapFee = _devFee.add(_marketingFee).add(_giveawaysFee).add(_iBNBPoolFee);
        maxTxAmount = _tTotal.div(100);
        swapEnabled = true;
   }
        
   function setMarketingWallet(address _address) external onlyOwner returns (bool){
        marketingWallet = _address;
        _isExcludedFromFee[marketingWallet] = true;
        return true;
    }
    function setDevWallet(address _address) external onlyOwner returns (bool){
        devWallet = _address;
        _isExcludedFromFee[devWallet] = true;
        return true;
    }
    function setGiveawaysWallet(address _address) external onlyOwner returns (bool){
        giveawaysWallet = _address;
        _isExcludedFromFee[giveawaysWallet] = true;
        return true;
    }
    function setIBNBPool(address _address) external onlyOwner returns (bool){
        iBNBPool = _address;
        _isExcludedFromFee[iBNBPool] = true;
        return true;
    }
    
    function setFees(uint256 taxFee, uint256 devFee, uint256 marketingFee, uint256 giveawaysFee, uint256 iBNBPoolFee) external onlyOwner{
        _taxFee = taxFee;
        _devFee = devFee;
        _marketingFee = marketingFee;
        _giveawaysFee = giveawaysFee;
        _iBNBPoolFee = iBNBPoolFee;
        _swapFee = _devFee.add(_marketingFee).add(_giveawaysFee).add(_iBNBPoolFee);
    }
    
    function setSellFees(uint256 sellTaxFee, uint256 sellDevFee, uint256 sellMarketingFee, uint256 sellGiveawaysFee, uint256 sellIBNBPoolFee) external onlyOwner{
        _sellTaxFee = sellTaxFee;
        _sellDevFee = sellDevFee;
        _sellMarketingFee = sellMarketingFee;
        _sellGiveawaysFee = sellGiveawaysFee;
        _sellIBNBPoolFee = sellIBNBPoolFee;
    }
    
    function setTotalFees(uint256 _totFees) external onlyOwner{
        totFees = _totFees;
    }
    
    function setTotalSellFees(uint256 _totSellFees) external onlyOwner{
        totSellFees = _totSellFees;
    }
    
    function setMaxSellAmountPerDay(uint256 amount) external onlyOwner{
        maxSellPerDay = amount * 10**9;
    }

    function setSwapEnabled(bool _enabled) public onlyOwner {
        swapEnabled = _enabled;
        emit swapEnabledUpdated(_enabled);
    }
    
    function setNumTokensTosSwap(uint256 amount) external onlyOwner{
        minTokensToSwap = amount * 10**9;
    }
    
    function setMaxTxAmount(uint256 amount) external onlyOwner{
        maxTxAmount = amount * 10**9;
    }
    

    function removeAllFee() private {
        if(totFees == 0) return;
        
        previousTotFees = totFees;
        
        totFees = 0;
    }
    
    function restoreAllFee() private {
        totFees = previousTotFees;
    }
    
    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(!_isBot[from] && !_isBot[to], "Bots are not allowed");
        
        if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
            require(amount <= maxTxAmount, 'you are exceeding maxTxAmount');
        }
        
        if(!_isExcludedFromFee[from] && to == pancakePair){
            if(block.timestamp < _firstSell[from].add(24 * 1 hours)){
                require(_totSells[from].add(amount) <= maxSellPerDay, "You can't sell more than maxSellPerDay");
                _totSells[from] = _totSells[from].add(amount);
            }
            else{
                _firstSell[from] = block.timestamp;
                _totSells[from] = amount;
            }
                
        }
        
        uint256 contractTokenBalance = balanceOf(address(this));
        
        bool overMinTokenBalance = contractTokenBalance >= minTokensToSwap;
        if (
            overMinTokenBalance &&
            !inSwap &&
            from != pancakePair &&
            swapEnabled
        ) {
            contractTokenBalance = minTokensToSwap;
            swapAndSendToFees(contractTokenBalance);
        }
        
        //indicates if fee should be deducted from transfer
        bool takeFee = true;
        bool isSale = false;
        
        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }
        
        if(to == pancakePair && takeFee){
            isSale = true;
        }
        
        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from,to,amount,takeFee, isSale);
    }
    
    function swapAndSendToFees(uint256 tokens) private lockTheSwap{
        uint256 initialBalance = address(this).balance;
        swapTokensForEth(tokens);
        uint256 transferBalance = (address(this).balance).sub(initialBalance);
        
        payable(marketingWallet).transfer(transferBalance.div(_swapFee).mul(_marketingFee));
        payable(devWallet).transfer(transferBalance.div(_swapFee).mul(_devFee));
        payable(giveawaysWallet).transfer(transferBalance.div(_swapFee).mul(_giveawaysFee));
        payable(iBNBPool).transfer(transferBalance.div(_swapFee).mul(_iBNBPoolFee));
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pancakeRouter.WETH();

        _approve(address(this), address(pancakeRouter), tokenAmount);

        // make the swap
        pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee, bool isSale) private {
        if(isSale && takeFee){
            totFees = totSellFees;
        }
        if(!takeFee)
            removeAllFee();
            
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient,  amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient,  amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient,  amount);
        } else {
            _transferStandard(sender, recipient,  amount);
        }
        
        if(!takeFee || isSale)
            restoreAllFee();
    }

   function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSwap) = _getValues(tAmount);

        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);

		_takeSwapFees(tSwap);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSwap) = _getValues(tAmount);

        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);

		_takeSwapFees(tSwap);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSwap) = _getValues(tAmount);

        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);

		_takeSwapFees(tSwap);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSwap) = _getValues(tAmount);

        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);

		_takeSwapFees(tSwap);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
            //////////////////////////
           /// Emergency functions //
          //////////////////////////
    function rescueBNBFromContract() external onlyOwner {
        address payable _owner = payable(msg.sender);
        _owner.transfer(address(this).balance);
    }
    
    function manualSwap() external onlyOwner{
        uint256 tokensToSwap = balanceOf(address(this));
        swapTokensForEth(tokensToSwap);
    }
    
    function manualSend() external onlyOwner{
        swapAndSendToFees(address(this).balance);
    }
    
    function startTrading() external onlyOwner{
        tradingEnabled = true;
    }
    
    function setAntiBot(address account, bool isBot) external onlyOwner{
        _isBot[account] = isBot;
    }
    
    function checkBot(address account) public view returns(bool){
        return _isBot[account];
    }
    
    function setRouterAddress(address newRouter) external onlyOwner {
        require(address(pancakeRouter) != newRouter, 'Router already set');
        //give the option to change the router down the line 
        IRouter _newRouter = IRouter(newRouter);
        address get_pair = IFactory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
        //checks if pair already exists
        if (get_pair == address(0)) {
            pancakePair = IFactory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
        }
        else {
            pancakePair = get_pair;
        }
        pancakeRouter = _newRouter;
    }
    
}
