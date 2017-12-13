class GithubProjectColumn < SimpleDelegator
  include OctokitConnection

  def self.by_id(id)
    new client.project_column(id)
  end

  def self.project_column_by_name(project_id, name)
    new client.project_columns(project_id).detect { |c| c.name == name }
  end

  def project_id
    ExtractUrlId.(:projects, project_url)
  end
end
