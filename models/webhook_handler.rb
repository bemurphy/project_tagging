class WebhookHandler
  def self.handles?(payload)
    raise "return a boolean"
  end

  def self.call(payload)
    # TODO, this should ultimately be the entry point
    # to enqueue a background job instead, but no
    # job system yet
    raise "handle the payload"
  end
end
