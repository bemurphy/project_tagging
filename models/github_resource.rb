class GithubResource
  class << self
    def client
      @@client ||= Octokit::Client.new
    end
  end

  def self.all(repo)
    client.public_send(resources_name, repo)
  end

  def self.find(repo, id)
    rel = client.repo(repo).rels[resources_name.to_sym]
    rel.get(uri: { id: id })
  end

  def self.resource_name
    # TODO haha
    name.to_s.downcase
  end

  def self.resources_name
    # TODO haha
    resource_name + "s"
  end

  def self.headers
    { accept: "application/vnd.github.inertia-preview+json" }
  end
end
