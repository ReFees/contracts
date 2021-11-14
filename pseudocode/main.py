============================================================
REFEES{
all_contracts : List[subscritpion_contract]
balances      : dict(address -> float )
}
============================================================
subscritpion_contract
{
####### essential constants
val maturity = None
...
val alpha    = None
####### addresses
val client_address
val provider_address
####### variables
start_block = None
gas_used = None
client_payemetns : {"block_id" : amount}
###### trade prices
trade_client   = False
trade_provider = False
client_price   = 0
provider_prive = 0
###### reference to REFEES
def init(maturity,....,alpha):
	# initialize variables
	...
	# initialize addresses
	client_address   = msg.sender
	provider_address = msg.sender
def start():
	if client_address !=provider_address:
		start_block = now()

def update():
	"""update the stae of the contract : clients payements, use of gas..."""
	fetch_gas_usage()

def fetch_gas_usage():
	"""uses etherscan to obtain the gas used by the client"""
	gas_used = Etherscan.get("gas used",client_address)

def pay(amount):
	

def enable_trade_client(price):
	trade_client  = True
	client_price  = price
def trade_client()
	if REFEES.transfer(msg.sender,client_address,client_price):
		trade_client  = False
		client_price  = 0
		client_address = msg.sender
def enable_trade_provider(price):
	trade_provider  = True
	provider_price  = price
def trade_provider()
	if REFEES.transfer(msg.sender,provider_address,provider_price):
		trade_provider  = False
		provider_price  = 0
		provider_address = msg.sender
	
		
}