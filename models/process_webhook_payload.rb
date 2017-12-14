class ProcessWebhookPayload
  def self.call(payload)
    handlers = available_handlers.select { |h| h.handles?(payload) }
    handlers.map { |h| h.(payload) }
  end

  def self.available_handlers
    [
      UpdateIssuesLabelsFromColumn::Handler,
      CreateProjectTemplate::Handler,
      MoveIssueToColumn::Handler,
      IssueCardMapping::DeleteHandler,
      IssueCardMapping::UpdateHandler
    ].freeze
  end
end
