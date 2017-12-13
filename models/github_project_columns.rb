class GithubProjectColumns < GithubResource
  def self.by_id(id)
    client.project_column(id)
  end

  def self.project_column_by_name(project_id, name)
    client.project_columns(project_id, headers).detect { |c| c.name == name }
  end
end
