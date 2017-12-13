class GithubProjectCard < SimpleDelegator
  include OctokitConnection

  def self.by_id(id)
    new client.project_card(id)
  end

  def column_id
    ExtractUrlId.(:columns, column_url)
  end

  def column
    if column_id
      GithubProjectColumn.by_id(column_id)
    end
  end

  def issue_number
    ExtractUrlId.(:issues, content_url)
  end

  def issue_repo
    content_url.match(%r{/repos/(.+?)/issues/\d+\z}) { |m| m[1] }
  end

  def issue
    if issue_repo && issue_number
      GithubIssue.by_number(issue_repo, issue_number)
    end
  end
end
