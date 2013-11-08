json.array!(@commits) do |commit|
  json.extract! commit, :test_pushed
  json.url commit_url(commit, format: :json)
end
