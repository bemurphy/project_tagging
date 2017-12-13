class GithubProject < GithubResource
  def self.find(repo, id)
    client.projects(repo, uri: { id: id }).first
  end
end
