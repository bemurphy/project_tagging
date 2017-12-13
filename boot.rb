require "cuba"
require "cuba/contrib"
require "mote"
require "octokit"
require "ohm"
require "ohm/contrib"
require "rack/protection"
require "scrivener"
require "scrivener_errors"
require "shield"

ENV["OCTOKIT_SILENT"] = (ENV["OCTOKIT_SILENT"] != "false").to_s

# Require all application files.
require_relative "./models/octokit_connection"
Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

# Require all helper files.
Dir["./helpers/**/*.rb"].each { |rb| require rb }
Dir["./filters/**/*.rb"].each { |rb| require rb }

ACCESS_TOKEN = ENV.fetch("ACCESS_TOKEN")

REPO = "bemurphy/project_tagging"

Octokit.configure do |c|
  c.access_token = ACCESS_TOKEN
end
