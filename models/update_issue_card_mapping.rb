class UpdateIssueCardMapping
  def call(card_id)
    card         = GithubProjectCard.by_id(card_id)
    column_id    = ExtractUrlId.(:columns, card.column_url)
    column       = GithubProjectColumns.by_id(column_id)
    project_id   = ExtractUrlId.(:projects, column.project_url)
    mapping      = IssueCardMapping.by_card_id(card.id) || IssueCardMapping.new
    issue_number = ExtractUrlId.(:issues, card.content_url)

    mapping.update(card_id: card.id, issue_number: issue_number, project_id: project_id)
  end
end
