defmodule BankEs.Events.MoneyDeposited do
  @derive Jason.Encoder
  defstruct [:account_number, :amount, :transfer_uuid]

  defimpl BankEs.EventString, for: __MODULE__ do
    def to_event_string(%{amount: _amount}) do
      "Deposit"
    end

    def for_statement(%{amount: amount} = event) do
      {amount, to_event_string(event)}
    end
  end
end
