# Hook up the handler (with a subscription) to the DomainEventPublisher

Wisper.subscribe(Notifications::DomainEventHandler, scope: :DomainEventPublisher, async: true)
