class CreateProjectTemplate
  include OctokitConnection

  COLUMN_NAMES = [
    "Backlog",
    "In Progress",
    "Ready for Review",
    "Ready to Land",
    "Deployed Week 1",
    "Landed",
    "Dropped",
  ]

  def call(project_id)
    COLUMN_NAMES.each do |name|
      begin
        client.create_project_column(project_id, name)
      rescue Octokit::UnprocessableEntity => e
        unless e.errors.to_s =~ /name.+taken/i
          raise
        end
      end
    end
  end

  class Handler < WebhookHandler
    def self.handles?(payload)
      payload["project"] && payload["action"] == "created"
    end

    def self.call(payload)
      project_id = payload["project"]["id"]
      CreateProjectTemplate.new.(project_id)
    end
  end
end
