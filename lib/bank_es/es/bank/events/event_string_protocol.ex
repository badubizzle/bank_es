defprotocol BankEs.EventString do
  @fallback_to_any true
  def to_event_string(event)
  def for_statement(event)
end

defimpl BankEs.EventString, for: Any do
  def to_event_string(event) do
    "#{inspect(event)}"
  end

  def for_statement(_event) do
    raise "Not implemented"
  end
end
