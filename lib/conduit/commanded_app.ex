defmodule Conduit.CommandedApp do
  use Commanded.Application,
    otp_app: :conduit,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Conduit.EventStore
    ]

  router(Conduit.Router)
end
