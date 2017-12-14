class CardConversion
  class Handler < WebhookHandler
    def self.handles?(payload)
      payload["project_card"] && payload["action"] = "converted"
    end

    def self.call(payload)
      card_id = payload["project_card"]["id"]
      mapping = UpdateIssueCardMapping.new.call(card_id)

      UpdateIssuesLabelsFromColumn.new.(card_id)
    end
  end
end
