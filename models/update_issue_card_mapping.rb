class UpdateIssueCardMapping
  def call(card_id)
    card         = GithubProjectCard.by_id(card_id)
    mapping      = IssueCardMapping.by_card_id(card.id) || IssueCardMapping.new
    issue_number = ExtractUrlId.(:issues, card.content_url)

    mapping.update(
      card_id: card.id,
      issue_number: issue_number,
      project_id: card.column.project_id
    )
  end
end
