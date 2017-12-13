class MoveIssueToColumn
  def self.handle_repo_issue_number(repo, number)
    issue = GithubIssue.by_number(repo, number)

    if mapping = IssueCardMapping.find(issue_number: number).first
      column = LabelsToColumn.new(mapping.project_id, issue.labels).column
      new.(issue, column)
    end
  end

  def call(issue, column)
    if column && card = locate_issue_card(issue)
      move(card, column)
    end
  end

  private

  def move(card, column)
    if card.column_url != column.url
      client.move_project_card(card.id, "bottom", column_id: column.id)
    end
  end

 def client
    GithubResource.client
  end

  def locate_issue_card(issue)
    if mapping = IssueCardMapping.by_issue_number(issue.number)
      mapping.github_card
    end
  end
end
