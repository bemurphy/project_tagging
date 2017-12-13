class GithubProjectCard
  include OctokitConnection

  def self.by_id(id)
    client.project_card(id)
  end
end
