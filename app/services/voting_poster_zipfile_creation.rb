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
        poster = VotingPosterCreation.call(exhibit)
        zip.put_next_entry(poster[:filename])
        zip.write(poster[:pdf])
      end
    end
    zip_stream.rewind
    zip_stream.read
  end

end
