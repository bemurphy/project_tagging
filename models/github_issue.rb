class GithubIssue < GithubResource
  def self.by_number(repo, number)
    rel = client.repo(repo).rels[:issues]
    rel.get(uri: { number: number }).data
  end
end
