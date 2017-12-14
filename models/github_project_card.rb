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
    if has_content_url?
      ExtractUrlId.(:issues, content_url)
    end
  end

  def issue_repo
    if has_content_url?
      content_url.match(%r{/repos/(.+?)/issues/\d+\z}) { |m| m[1] }
    end
  end

  def issue
    if issue_repo && issue_number
      GithubIssue.by_number(issue_repo, issue_number)
    end
  end

  private

  def has_content_url?
    # A card with no issue has not content_url_method
    respond_to?(:content_url)
  end
end
