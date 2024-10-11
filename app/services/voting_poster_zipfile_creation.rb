# frozen_string_literal: true

class VotingPosterZipfileCreation < ApplicationService

  def initialize(event)
    @event = event
  end

  def call
    voting_poster_zipfile
  end

  private

  def voting_poster_zipfile
    require 'zip'

    zip_stream = Zip::OutputStream.write_buffer do |zip|
      @event.exhibits.each do |exhibit|
        next unless exhibit.is_approved? and exhibit.votable?
        voting_poster = VotingPosterCreation.call(exhibit)
        zip.put_next_entry("voting-poster.#{exhibit.id}-#{exhibit.platform_position}.pdf")
        zip.write(voting_poster)
      end
    end
    zip_stream.rewind
    zip_stream.read
  end

end
