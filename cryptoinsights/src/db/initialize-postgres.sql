CREATE DATABASE cryptoinsights

CREATE TABLE cryptoinsights.exchanges (
  id serial PRIMARY KEY,
  name text NOT NULL,
  # timestamps
  created_at timestamp DEFAULT now(),
  modified_at timestamp DEFAULT now()
);


CREATE TABLE cryptoinsights.cryptos (
  id serial PRIMARY KEY,
  name text NOT NULL,
  symbol text NOT NULL,
  # references
  exchange_id integer NOT NULL REFERENCES exchanges(id),
  created_at timestamp DEFAULT now(),
  # timestamps
  modified_at timestamp DEFAULT now()
);

CREATE TABLE cryptoinsights.markets (
  id serial PRIMARY KEY,
  name text NOT NULL,
  # references
  base_crypto_id integer NOT NULL REFERENCES cryptos(id),
  crypto_id integer NOT NULL REFERENCES cryptos(id),
  exchange_id integer NOT NULL REFERENCES exchanges(id),
  # timestamps
  created_at timestamp DEFAULT now()
  modified_at timestamp DEFAULT now()
);

CREATE TABLE cryptoinsights.market_snapshots (
  id serial PRIMARY KEY,
  name text NOT NULL,
  # prices
  high float(4) NOT NULL,
  low float(4) NOT NULL,
  last float(4) NOT NULL,
  previous_day float(4) NOT NULL,
  # volume
  volume float(4) NOT NULL,
  base_volume float(4) NOT NULL,
  # orders
  buy_orders_count int NOT NULL,
  sell_orders_count int NOT NULL,
  # references
  base_crypto_id integer NOT NULL REFERENCES cryptos(id),
  crypto_id integer NOT NULL REFERENCES cryptos(id),
  exchange_id integer NOT NULL REFERENCES exchanges(id),
  # timestamps
  created_at timestamp DEFAULT now()
  modified_at timestamp DEFAULT now()
);
