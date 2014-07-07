json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :name, :status, :duedate
  json.url assignment_url(assignment, format: :json)
end
