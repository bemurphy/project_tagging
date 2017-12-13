class ResyncIssueCardMappings
  def call(repo_name)
    IssueCardMapping.all.to_a.map(&:delete)

    client.projects(repo_name).each do |project|
      project_columns = client.project_columns(project.id)
      cards = project_columns.map { |c| client.column_cards(c.id) }.flatten

      cards.each do |card|
        if issue_number = ExtractUrlId.(:issues, card.content_url)
          IssueCardMapping.create_unless_exists(
            card_id: card.id,
            issue_number: issue_number,
            project_id: project.id
          )
        end
      end
    end
  end

  private

  def client
    GithubResource.client
  end
end
