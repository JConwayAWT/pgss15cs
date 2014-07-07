json.array!(@submissions) do |submission|
  json.extract! submission, :id, :version_number, :feedback
  json.url submission_url(submission, format: :json)
end
