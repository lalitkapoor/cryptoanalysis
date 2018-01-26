https://bittrex.com/home/api

Public Api
/public/getmarkets
Used to get the open and available trading markets at Bittrex along with other meta data.

Parameters
None

Request:
https://bittrex.com/api/v1.1/public/getmarkets
Response

```
{
	"success" : true,
	"message" : "",
	"result" : [{
			"MarketCurrency" : "LTC",
			"BaseCurrency" : "BTC",
			"MarketCurrencyLong" : "Litecoin",
			"BaseCurrencyLong" : "Bitcoin",
			"MinTradeSize" : 0.01000000,
			"MarketName" : "BTC-LTC",
			"IsActive" : true,
			"Created" : "2014-02-13T00:00:00"
		}, {
			"MarketCurrency" : "DOGE",
			"BaseCurrency" : "BTC",
			"MarketCurrencyLong" : "Dogecoin",
			"BaseCurrencyLong" : "Bitcoin",
			"MinTradeSize" : 100.00000000,
			"MarketName" : "BTC-DOGE",
			"IsActive" : true,
			"Created" : "2014-02-13T00:00:00"
		}
    ]
}
```

/public/getcurrencies
Used to get all supported currencies at Bittrex along with other meta data.

Parameters
None

Request:
https://bittrex.com/api/v1.1/public/getcurrencies
Response

```
{
	"success" : true,
	"message" : "",
	"result" : [{
			"Currency" : "BTC",
			"CurrencyLong" : "Bitcoin",
			"MinConfirmation" : 2,
			"TxFee" : 0.00020000,
			"IsActive" : true,
			"CoinType" : "BITCOIN",
			"BaseAddress" : null
		}, {
			"Currency" : "LTC",
			"CurrencyLong" : "Litecoin",
			"MinConfirmation" : 5,
			"TxFee" : 0.00200000,
			"IsActive" : true,
			"CoinType" : "BITCOIN",
			"BaseAddress" : null
		}
    ]
}
```

/public/getticker
Used to get the current tick values for a market.

Parameters
parameter required description
market required a string literal for the market (ex: BTC-LTC)
Request:
https://bittrex.com/api/v1.1/public/getticker
Response

```
{
	"success" : true,
	"message" : "",
	"result" : {
		"Bid" : 2.05670368,
		"Ask" : 3.35579531,
		"Last" : 3.35579531
	}
}
```

/public/getmarketsummaries
Used to get the last 24 hour summary of all active exchanges

Parameters
None

Request:
https://bittrex.com/api/v1.1/public/getmarketsummaries
Response

```
    {
	"success" : true,
	"message" : "",
	"result" : [{
			"MarketName" : "BTC-888",
			"High" : 0.00000919,
			"Low" : 0.00000820,
			"Volume" : 74339.61396015,
			"Last" : 0.00000820,
			"BaseVolume" : 0.64966963,
			"TimeStamp" : "2014-07-09T07:19:30.15",
			"Bid" : 0.00000820,
			"Ask" : 0.00000831,
			"OpenBuyOrders" : 15,
			"OpenSellOrders" : 15,
			"PrevDay" : 0.00000821,
			"Created" : "2014-03-20T06:00:00",
			"DisplayMarketName" : null
		}, {
			"MarketName" : "BTC-A3C",
			"High" : 0.00000072,
			"Low" : 0.00000001,
			"Volume" : 166340678.42280999,
			"Last" : 0.00000005,
			"BaseVolume" : 17.59720424,
			"TimeStamp" : "2014-07-09T07:21:40.51",
			"Bid" : 0.00000004,
			"Ask" : 0.00000005,
			"OpenBuyOrders" : 18,
			"OpenSellOrders" : 18,
			"PrevDay" : 0.00000002,
			"Created" : "2014-05-30T07:57:49.637",
			"DisplayMarketName" : null
		}
    ]
}
```

/public/getmarketsummary
Used to get the last 24 hour summary of all active exchanges

Parameters
parameter required description
market required a string literal for the market (ex: BTC-LTC)
Request:
https://bittrex.com/api/v1.1/public/getmarketsummary?market=btc-ltc
Response

```
{
	"success" : true,
	"message" : "",
	"result" : [{
			"MarketName" : "BTC-LTC",
			"High" : 0.01350000,
			"Low" : 0.01200000,
			"Volume" : 3833.97619253,
			"Last" : 0.01349998,
			"BaseVolume" : 47.03987026,
			"TimeStamp" : "2014-07-09T07:22:16.72",
			"Bid" : 0.01271001,
			"Ask" : 0.01291100,
			"OpenBuyOrders" : 45,
			"OpenSellOrders" : 45,
			"PrevDay" : 0.01229501,
			"Created" : "2014-02-13T00:00:00",
			"DisplayMarketName" : null
		}
    ]
}
```

/public/getorderbook
Used to get retrieve the orderbook for a given market

Parameters
parameter required description
market required a string literal for the market (ex: BTC-LTC)
type required buy, sell or both to identify the type of orderbook to return.
Request:
https://bittrex.com/api/v1.1/public/getorderbook?market=BTC-LTC&type=both
Response

```
    {
	"success" : true,
	"message" : "",
	"result" : {
		"buy" : [{
				"Quantity" : 12.37000000,
				"Rate" : 0.02525000
			}
		],
		"sell" : [{
				"Quantity" : 32.55412402,
				"Rate" : 0.02540000
			}, {
				"Quantity" : 60.00000000,
				"Rate" : 0.02550000
			}, {
				"Quantity" : 60.00000000,
				"Rate" : 0.02575000
			}, {
				"Quantity" : 84.00000000,
				"Rate" : 0.02600000
			}
		]
	}
}
```

/public/getmarkethistory
Used to retrieve the latest trades that have occured for a specific market.

Parameters
parameter required description
market required a string literal for the market (ex: BTC-LTC)
Request:
https://bittrex.com/api/v1.1/public/getmarkethistory?market=BTC-DOGE
Response - List of trades objects

```
    {
	"success" : true,
	"message" : "",
	"result" : [{
			"Id" : 319435,
			"TimeStamp" : "2014-07-09T03:21:20.08",
			"Quantity" : 0.30802438,
			"Price" : 0.01263400,
			"Total" : 0.00389158,
			"FillType" : "FILL",
			"OrderType" : "BUY"
		}, {
			"Id" : 319433,
			"TimeStamp" : "2014-07-09T03:21:20.08",
			"Quantity" : 0.31820814,
			"Price" : 0.01262800,
			"Total" : 0.00401833,
			"FillType" : "PARTIAL_FILL",
			"OrderType" : "BUY"
		}, {
			"Id" : 319379,
			"TimeStamp" : "2014-07-09T02:58:48.127",
			"Quantity" : 49.64643541,
			"Price" : 0.01263200,
			"Total" : 0.62713377,
			"FillType" : "FILL",
			"OrderType" : "SELL"
		}, {
			"Id" : 319378,
			"TimeStamp" : "2014-07-09T02:58:46.27",
			"Quantity" : 0.35356459,
			"Price" : 0.01263200,
			"Total" : 0.00446622,
			"FillType" : "PARTIAL_FILL",
			"OrderType" : "BUY"
		}
	]
}
```

Market Apis
/market/buylimit
Used to place a buy order in a specific market. Use buylimit to place limit orders. Make sure you have the proper permissions set on your API keys for this call to work

Parameters
parameter required description
market required a string literal for the market (ex: BTC-LTC)
quantity required the amount to purchase
rate required the rate at which to place the order.
Request:
https://bittrex.com/api/v1.1/market/buylimit?apikey=API_KEY&market=BTC-LTC&quantity=1.2&rate=1.3
Response - Returns you the order uuid

```
{
	"success" : true,
	"message" : "",
	"result" : {
			"uuid" : "e606d53c-8d70-11e3-94b5-425861b86ab6"
		}
}
```

/market/selllimit
Used to place an sell order in a specific market. Use selllimit to place limit orders. Make sure you have the proper permissions set on your API keys for this call to work

Parameters
parameter required description
market required a string literal for the market (ex: BTC-LTC)
quantity required the amount to purchase
rate required the rate at which to place the order
Request:
https://bittrex.com/api/v1.1/market/selllimit?apikey=API_KEY&market=BTC-LTC&quantity=1.2&rate=1.3
Response - Returns you the order uuid

```
{
	"success" : true,
	"message" : "",
	"result" : {
			"uuid" : "614c34e4-8d71-11e3-94b5-425861b86ab6"
		}
}
```

/market/cancel
Used to cancel a buy or sell order.

Parameters
parameter required description
uuid required uuid of buy or sell order
Request:
https://bittrex.com/api/v1.1/market/cancel?apikey=API_KEY&uuid=ORDER_UUID
Response - Returns you the order uuid

```
{
    "success" : true,
    "message" : "",
    "result" : null
}
```

/market/getopenorders
Get all orders that you currently have opened. A specific market can be requested

Parameters
parameter required description
market optional a string literal for the market (ie. BTC-LTC)
Request:
https://bittrex.com/api/v1.1/market/getopenorders?apikey=API_KEY&market=BTC-LTC
Response

```
    {
	"success" : true,
	"message" : "",
	"result" : [{
			"Uuid" : null,
			"OrderUuid" : "09aa5bb6-8232-41aa-9b78-a5a1093e0211",
			"Exchange" : "BTC-LTC",
			"OrderType" : "LIMIT_SELL",
			"Quantity" : 5.00000000,
			"QuantityRemaining" : 5.00000000,
			"Limit" : 2.00000000,
			"CommissionPaid" : 0.00000000,
			"Price" : 0.00000000,
			"PricePerUnit" : null,
			"Opened" : "2014-07-09T03:55:48.77",
			"Closed" : null,
			"CancelInitiated" : false,
			"ImmediateOrCancel" : false,
			"IsConditional" : false,
			"Condition" : null,
			"ConditionTarget" : null
		}, {
			"Uuid" : null,
			"OrderUuid" : "8925d746-bc9f-4684-b1aa-e507467aaa99",
			"Exchange" : "BTC-LTC",
			"OrderType" : "LIMIT_BUY",
			"Quantity" : 100000.00000000,
			"QuantityRemaining" : 100000.00000000,
			"Limit" : 0.00000001,
			"CommissionPaid" : 0.00000000,
			"Price" : 0.00000000,
			"PricePerUnit" : null,
			"Opened" : "2014-07-09T03:55:48.583",
			"Closed" : null,
			"CancelInitiated" : false,
			"ImmediateOrCancel" : false,
			"IsConditional" : false,
			"Condition" : null,
			"ConditionTarget" : null
		}
	]
}
```
