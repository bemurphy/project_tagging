class UpdateIssueCardMapping
  def call(card_id)
    card    = GithubProjectCard.by_id(card_id)
    mapping = IssueCardMapping.by_card_id(card.id) || IssueCardMapping.new

    mapping.update(
      card_id: card.id,
      issue_number: card.issue_number,
      project_id: card.column.project_id
    )

    mapping
  end
end
