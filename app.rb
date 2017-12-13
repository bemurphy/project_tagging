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

    if payload["issue"]
      MoveIssueToColumn.handle_repo_issue_number(
        payload["repository"]["full_name"],
        payload["issue"]["number"]
      )
    elsif payload["project_card"]
      card_id = payload["project_card"]["id"]
      UpdateIssueCardMapping.new.call(card_id)
    end

    res.write "ok"
  end
end
