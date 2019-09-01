defmodule BankEs.Events.MoneyWithdrawn do
  @derive Jason.Encoder
  defstruct [:account_number, :amount, :transfer_uuid]

  defimpl BankEs.EventString, for: __MODULE__ do
    def to_event_string(%{amount: _amount}) do
      "Withdrawal"
    end

    def for_statement(%{amount: amount} = event) do
      {-1 * amount, to_event_string(event)}
    end
  end
end
