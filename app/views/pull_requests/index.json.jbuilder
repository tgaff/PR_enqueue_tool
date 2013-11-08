json.array!(@pullrequests) do |pullrequest|
  json.extract! pullrequest, :number
  json.url pullrequest_url(pullrequest, format: :json)
end
