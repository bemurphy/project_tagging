require "pp"

class UpdateIssuesLabelsFromColumn
  include OctokitConnection

  # TODO unify the data here with LabelsToColumn
  MAPPING = {
    "Backlog"          => nil,
    "In Progress"      => "in progress",
    "Ready for Review" => "review",
    "Ready to Land"    => "thumbsup"
  }

  SPECIAL_LABELS = MAPPING.values.compact

  def call(card_id)
    card   = GithubProjectCard.by_id(card_id)
    column = card.column
    issue  = card.issue

    label_to_add    = MAPPING[column.name]
    existing_labels = issue.labels.map(&:name)
    new_labels      = ((existing_labels - SPECIAL_LABELS) + [label_to_add]).compact

    if existing_labels.sort != new_labels.sort
      client.replace_all_labels(issue.repo, issue.number, new_labels)
    end
  end

  class Handler < WebhookHandler
    def self.handles?(payload)
      payload["project_card"] && payload["action"] == "moved"
    end

    def self.call(payload)
      UpdateIssuesLabelsFromColumn.new.call(payload["project_card"]["id"])
    end
  end
end
