class ProcessWebhookPayload
  def self.call(payload)
    if payload["project"] && payload["action"] == "created"
      project_id = payload["project"]["id"]
      CreateProjectTemplate.new.(project_id)
    elsif payload["issue"] && payload["action"].to_s =~ /label/
      MoveIssueToColumn.handle_repo_issue_number(
        payload["repository"]["full_name"],
        payload["issue"]["number"]
      )
    elsif payload["project_card"] && payload["action"] == "deleted"
      card_id = payload["project_card"]["id"]
      if mapping = IssueCardMapping.by_card_id(card_id)
        mapping.delete
      end
    elsif payload["project_card"] && payload["action"] != "deleted"
      card_id = payload["project_card"]["id"]
      mapping = UpdateIssueCardMapping.new.call(card_id)

      # If the issue was created with a label, then added to a project
      # we need to react to move it to the proper column
      #
      # TODO extract this out to something clean
      # TODO get the repo from the payload content_url or card -> issue -> repo instead as well
      if payload["action"] == "created"
        if mapping.issue_number
          MoveIssueToColumn.handle_repo_issue_number(
            payload["repository"]["full_name"],
            mapping.issue_number
          )
        end
      end
    end
  end
end
