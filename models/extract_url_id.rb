class ExtractUrlId
  def self.call(collection_name, url)
    url.match(%r{/#{collection_name}/(\d+)\z})[1]
  end
end
