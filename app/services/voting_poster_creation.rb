# frozen_string_literal: true

class VotingPosterCreation < ApplicationService
  include Rails.application.routes.url_helpers

  require 'prawn'

  def initialize(exhibit)
    @exhibit = exhibit
    @url = new_vote_url(@exhibit)
  end

  def call
    voting_poster
  end

  private

  def voting_poster
    pdf = Prawn::Document.new(top_margin: 5, left_margin: 5, page_size: 'A6', page_layout: :landscape, print_scaling: :none)
    pdf.text @exhibit.event_title
    current_locale = I18n.locale
    I18n.locale = :de
    pdf.text I18n.t('voting_poster_intro')
    pdf.text I18n.t('voting_poster_instruction')
    I18n.locale = :en
    pdf.text I18n.t('voting_poster_intro')
    pdf.text I18n.t('voting_poster_instruction')
    I18n.locale = current_locale
    pdf.text @exhibit.name
    pdf.text @exhibit.platform_position
    pdf.image StringIO.new( qr_png.to_datastream.to_s )
    pdf.text @url
    pdf.render
  end

  def qr_png
    RQRCode::QRCode.new(@url).as_png
  end
end
