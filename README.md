# BankEs

## EventSourcing and CQRS application in Elixir

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix db.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start endpoint with `make run-dev`

```elixir
iex> {:ok, account} = BankEs.create_account()

iex> {:ok, account} = BankEs.deposit_money(account.account_number, 100)

iex> account.balance

iex> {:ok, account} = BankEs.withdraw_money(account.account_number, 50)

iex> account.balance

iex> BankEs.print_statement(account.account_number)
```
