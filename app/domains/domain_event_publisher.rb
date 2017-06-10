class DomainEventPublisher
  include Wisper::Publisher

  def call(event_name, *event_params)
    broadcast(event_name, *event_params)
  end
end
