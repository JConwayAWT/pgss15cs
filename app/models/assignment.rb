class Assignment < ActiveRecord::Base
  belongs_to :user
  has_many :submissions, dependent: :destroy

  has_attached_file :document,
    path: "assignments/:id/:filename"

  attr_accessor :advanced_lab_only
  attr_accessor :advanced_section_only
  attr_accessor :name_search_parameter
  attr_accessor :student

  do_not_validate_attachment_file_type :document

  def latest_version
    submissions = self.submissions.sort_by {|subs| subs.version_number}
    submissions.reverse.each do |sub|
      if sub.document.exists?
        return sub
      end
    end
  end

  def needs_review?
    submissions = self.submissions.sort_by {|subs| subs.version_number}
    submissions.reverse.each do |sub|
      if sub.document.exists? and sub.feedback.blank?
        return true
      end
    end
    return false
  end

  def submitted_late
    due_date_time = self.duedate
    submissions = self.submissions.sort_by {|subs| subs.version_number}
    if (Time.now > due_date_time) and !submissions.first.document.exists?
      return true
    elsif (Time.now > due_date_time) and (submissions.first.document_updated_at > due_date_time)
      return true
    else
      return false
    end
  end

  def latest_version_download_link
    submissions = self.submissions.sort_by {|subs| subs.version_number}
    submissions.reverse.each do |sub|
      if sub.document.exists?
        return sub.document.url
      end
    end
    "#"
  end

  def has_some_submission
    submissions = self.submissions.sort_by {|subs| subs.version_number}
    return true if submissions.first.document.exists?
    return false
  end

  def self.create_assignment_for_all_students(assignment_params, params)
    User.all.each do |u|
      next if params[:assignment][:advanced_lab_only] == "1" and u.advanced_lab != true
      next if params[:assignment][:advanced_section_only] == "1" and u.cs_advanced_section != true
      next if params[:assignment][:advanced_lab_only] == "0" and params[:assignment][:advanced_section_only] == "0" and u.cs_advanced_section == true
      if u.type == :student
        a = Assignment.new(assignment_params)
        (1..4).each do |k|
          s = Submission.new()
          s.version_number = k
          s.feedback = ""
          s.save!
          a.submissions << s
        end
        a.status = "Open"
        a.instructions = params[:assignment][:instructions]
        a.document = params[:assignment][:document]
        # debugger
        a.save!
        u.assignments << a
        u.save!
      end
    end
  end

end

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end