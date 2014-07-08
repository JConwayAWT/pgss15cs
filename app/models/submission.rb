class Submission < ActiveRecord::Base
  belongs_to :assignment

  attr_accessor :status

  has_attached_file :document, 
      path: "submissions/:id/:filename"

  do_not_validate_attachment_file_type :document

  def not_ready_yet
    partner_submissions = self.assignment.submissions
    my_version_number = self.version_number
    if my_version_number == 1
      return false
    else
      if partner_submissions.find_by_version_number(my_version_number - 1).document.exists? and !partner_submissions.find_by_version_number(my_version_number - 1).feedback.blank?
        return false
      else
        return true
      end
    end
  end
end
