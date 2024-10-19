# frozen_string_literal: true

class VotingPosterCreation < ApplicationService
  include Rails.application.routes.url_helpers

  require 'prawn'
  require 'prawn/measurement_extensions'
  require 'open-uri'

  def initialize(exhibit)
    @exhibit = exhibit
    @url = new_vote_url(@exhibit)
  end

  def call
    { pdf: voting_poster, filename: filename }
  end

  def filename
    type = @exhibit.is_collab? ? 'COLLAB' : 'MOC';
    "#{type}-voting-#{@exhibit.id}-#{@exhibit.platform_position}.pdf"
  end

  private

  def voting_poster
    throw "Exhibit #{@exhibit.to_s} is not votable" if not @exhibit.votable?
    pdf = Prawn::Document.new(margin: 7, page_size: 'A6', page_layout: :landscape, print_scaling: :none)
    width = pdf.bounds.width
    height = pdf.bounds.height
    logo_url = @exhibit.attendance.event.logo_url
    unless logo_url.blank?
      pdf.image URI.parse(logo_url).open,
                position: :center, vposition: :top, width: width * 0.9, height: height * 0.2
    end
    pdf.text @exhibit.event_title, align: :center, style: :bold, size: 12

    pdf.float do
      pdf.image StringIO.new(qr_png.to_datastream.to_s), position: :right, vposition: :bottom, scale: 1.20
    end

    pdf.float do
      pdf.move_cursor_to 2.mm
      pdf.text @url, align: :right, size: 5
    end

    pdf.float do
      pdf.bounding_box([0, 110], width: 275, height: 70) do
        current_locale = I18n.locale
        I18n.locale = :de
        pdf.text I18n.t('voting_poster_intro'), align: :right
        pdf.text I18n.t('voting_poster_instruction'), align: :right
        pdf.move_down 5.mm
        I18n.locale = :en
        pdf.text I18n.t('voting_poster_intro'), align: :right
        pdf.text I18n.t('voting_poster_instruction'), align: :right
        I18n.locale = current_locale
      end
    end

    pdf.float do
      pdf.text_box "#{@exhibit.name}" +
                     "#{'<br/><font size=\'12\'> (' + @exhibit.installation.name + ')</font>' if @exhibit.installation}" +
                     "#{'<br/><font size=\'10\'> (Gemeinschaftsprojekt / Collab)</font>' if @exhibit.is_collab?}",
                   inline_format: true,
                   at: [0, 210],
                   width: width,
                   height: 80,
                   overflow: :shrink_to_fit,
                   style: :bold, size: 24,
                   align: :center, valign: :center
    end

    pdf.float do
      pdf.bounding_box([0, 40], width: 275, height: 40) do
        pdf.text @exhibit.platform_position, style: :bold, size: 24, valign: :bottom
      end
    end

    pdf.render
  end

  def qr_png
    RQRCode::QRCode.new(@url).as_png
  end
end
