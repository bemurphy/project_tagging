class GithubProjectCard < GithubResource
  def self.by_id(id)
    client.project_card(id)
  end

  def self.by_issue(issue)
    if mapping = IssueCardMapping.find(issue_id: issue.id)
      by_id(mapping.card_id)
    end
  end
end
