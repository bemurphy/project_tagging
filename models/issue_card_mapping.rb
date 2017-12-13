class IssueCardMapping < Ohm::Model
  attribute :card_id
  attribute :issue_number
  attribute :project_id

  index :card_id
  index :issue_number

  def self.by_card_id(card_id)
    find(card_id: card_id).first
  end

  def self.by_issue_number(number)
    IssueCardMapping.find(issue_number: number).first
  end

  def self.create_unless_exists(card_id:, issue_number:, project_id:)
    find(issue_number: issue_number).first ||
      create(card_id: card_id, issue_number: issue_number, project_id: project_id)
  end

  def github_card
    GithubProjectCard.by_id(card_id)
  end
end
