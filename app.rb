require "cuba"
require "cuba/contrib"
require "json"
require "mote"
require "ohm"
require "ohm/contrib"
require "rack/protection"
require "scrivener"
require "scrivener_errors"
require "shield"

require_relative "./boot.rb"

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::Prelude
Cuba.plugin ScrivenerErrors::Helpers
Cuba.plugin Shield::Helpers

Cuba.use Rack::MethodOverride
Cuba.use Rack::Session::Cookie,
  key: "my_new_app",
  secret: ENV.fetch("SESSION_SECRET")

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  root: "./public",
  urls: %w[/js /css /img]

Cuba.define do
  on post, "webhooks" do
    payload = JSON[req.params["payload"]]

    # Handlers like this, ActiveJob. Build a chain and
    # perform for anything that handles it. Use Que
    # for ACID jobs and transactions
    class HandlerJob
      def self.handles?(payload)
        payload["issue"] && payload["action"].to_s =~ /label/
      end

      def perform(payload)
        # consume the payload
      end
    end

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

    res.write "ok"
  end

  on root do
    res.write "OK"
  end
end
