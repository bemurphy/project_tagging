module OctokitConnection
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def client
      Thread.current[:_octokit_connection_client] ||= Octokit::Client.new
    end
  end

  private

  def client
    self.class.client
  end
end
