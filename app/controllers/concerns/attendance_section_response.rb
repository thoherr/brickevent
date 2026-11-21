# Saves and deletes started from a section of the attendance page (inside its
# Turbo Frame) are answered with a Turbo Stream that updates that section, the
# status line and the flash messages. Requests from anywhere else, e.g. the
# standalone edit pages linked from the event page, keep their redirect.
module AttendanceSectionResponse
  extend ActiveSupport::Concern

  SECTIONS = %w[attendees exhibits accommodations].freeze

  private

  def attendance_section_request?(section)
    turbo_frame_request_id == section
  end

  def render_attendance_section(attendance, section, notice)
    raise ArgumentError, "unknown section #{section}" unless SECTIONS.include?(section)

    flash.now[:notice] = notice
    # Called from the format.html branch of respond_to, which would otherwise
    # send the stream as text/html.
    render "attendances/section_update", formats: :turbo_stream, content_type: Mime[:turbo_stream].to_s,
           locals: { attendance: attendance.reload, section: section }
  end
end
