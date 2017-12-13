class GithubIssue < SimpleDelegator
  include OctokitConnection

  def self.by_number(repo, number)
    rel = client.repo(repo).rels[:issues]
    new rel.get(uri: { number: number }).data
  end

  def repo
    repository_url.match(%r{/repos/(.+?)\z}) { |m| m[1] }
  end
end
