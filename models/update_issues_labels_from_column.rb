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

    label_to_add = MAPPING[column.name]
    new_labels   = ((issue.labels.map(&:name) - SPECIAL_LABELS) + [label_to_add]).compact

    client.replace_all_labels(issue.repo, issue.number, new_labels)
  end
end
