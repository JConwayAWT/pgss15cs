class Submission < ActiveRecord::Base
  belongs_to :assignment

  has_attached_file :document, 
      path: "submissions/:id/:filename"

  do_not_validate_attachment_file_type :document

end
