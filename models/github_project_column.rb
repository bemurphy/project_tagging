class GithubProjectColumn < SimpleDelegator
  include OctokitConnection

  def self.by_id(id)
    new client.project_column(id)
  end

  def self.project_column_by_name(project_id, name)
    new client.project_columns(project_id).detect { |c| c.name == name }
  end

  # TODO get these strings into constants

  def self.backlog(project_id)
    client.project_column_by_name("Backlog")
  end

  def self.in_progress(project_id)
    client.project_column_by_name("In Progress")
  end

  def self.ready_for_review(project_id)
    client.project_column_by_name("Ready for Review")
  end

  def self.ready_to_land(project_id)
    client.project_column_by_name("Ready to Land")
  end

  def project_id
    ExtractUrlId.(:projects, project_url)
  end
end
