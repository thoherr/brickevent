# Rules for what can be changed on the attendance page. The sections are also
# rendered from the attendee, MOC and accommodation controllers (Turbo Stream
# responses), so these must not depend on instance variables set by
# AttendancesController#show.
module AttendancesHelper
  # Attendees may change their registration while the event's registration is
  # open; admins and event managers always.
  def registration_open?(attendance)
    attendance.event_registration_open? || user_is_admin? || !!attendance.event&.is_managed_by?(current_user)
  end

  def can_edit_attendees?(attendance)
    registration_open?(attendance) || !!attendance.event&.edit_of_attendees_allowed?
  end

  def can_edit_exhibits?(attendance)
    registration_open?(attendance) || !!attendance.event&.edit_of_exhibits_allowed
  end
end
