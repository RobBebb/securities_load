import yfinance as yf

tsla = yf.Ticker("TSLA")
expiries = tsla.options
print("Available expiries:", expiries)
# pick an expiry (e.g. the first one)
expiry = expiries[0]
# fetch the option chain for that expiry
opt_chain = tsla.option_chain(expiry)

print(f"Option chain length: {len(opt_chain)}")
# opt_chain.calls and opt_chain.puts are both pandas DataFrames
calls = opt_chain.calls
puts = opt_chain.puts
print(f"Option chain underlying: {opt_chain.underlying}")
print(f"Option chain underlying: {opt_chain.underlying['symbol']}")
print(f"Option chain calls: {len(calls)}")
print(f"Option chain puts: {len(puts)}")
print(f"Option chain calls columns: {calls.columns}")
print(f"Option chain puts columns: {puts.columns}")

print("\nCalls max open interest:\n", calls["openInterest"])
print("\nPuts:\n", puts.head())


# tsla_options = tsla.option_chain()
# print(tsla_options.calls)
# print(tsla_options.puts)
