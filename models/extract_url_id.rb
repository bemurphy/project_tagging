class ExtractUrlId
  def self.call(collection_name, url)
    url.to_s.match(%r{/#{collection_name}/(\d+)\z}) { |m| m[1] }
  end
end
