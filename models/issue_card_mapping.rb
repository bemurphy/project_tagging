class IssueCardMapping < Ohm::Model
  attribute :card_id
  attribute :issue_number
  attribute :project_id

  index :card_id
  index :issue_number

  def self.by_card_id(card_id)
    find(card_id: card_id).first
  end

  def self.by_issue_number(number)
    IssueCardMapping.find(issue_number: number).first
  end

  def self.create_unless_exists(card_id:, issue_number:, project_id:)
    find(issue_number: issue_number).first ||
      create(card_id: card_id, issue_number: issue_number, project_id: project_id)
  end

  def github_card
    GithubProjectCard.by_id(card_id)
  end

  class UpdateHandler < WebhookHandler
    def self.handles?(payload)
      payload["project_card"] && payload["action"] != "deleted"
    end

    def self.call(payload)
      card_id = payload["project_card"]["id"]
      mapping = UpdateIssueCardMapping.new.call(card_id)

      # If the issue was created with a label, then added to a project
      # we need to react to move it to the proper column
      #
      # TODO extract this out to something clean
      # TODO get the repo from the payload content_url or card -> issue -> repo instead as well
      if payload["action"] == "created"
        if mapping.issue_number
          MoveIssueToColumn.handle_repo_issue_number(
            payload["repository"]["full_name"],
            mapping.issue_number
          )
        end
      end
    end
  end

  class DeleteHandler < WebhookHandler
    def self.handles?(payload)
      payload["project_card"] && payload["action"] == "deleted"
    end

    def self.call(payload)
      card_id = payload["project_card"]["id"]

      if mapping = IssueCardMapping.by_card_id(card_id)
        mapping.delete
      end
    end
  end
end
