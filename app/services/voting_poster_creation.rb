# frozen_string_literal: true

class VotingPosterCreation < ApplicationService
  include Rails.application.routes.url_helpers

  require 'prawn'
  require 'prawn/measurement_extensions'
  require 'open-uri'

  def initialize(exhibit)
    @exhibit = exhibit
    @url = new_vote_url(@exhibit)
    @stroke_bounds = false
  end

  def call
    { pdf: voting_poster, filename: filename }
  end

  def filename
    type = @exhibit.is_collab? ? 'COLLAB' : 'MOC'
    "#{type}-voting-#{@exhibit.id}-#{@exhibit.platform_position}.pdf"
  end

  private

  def voting_poster
    throw "Exhibit #{@exhibit.to_s} is not votable" unless @exhibit.votable?

    pdf = Prawn::Document.new(margin: 7, page_size: 'A6', page_layout: :portrait, print_scaling: :none)

    width = pdf.bounds.width
    height = pdf.bounds.height
    name_top = height - 40
    name_height = 75
    instructions_top = name_top - name_height
    instructions_height = 60
    qr_top = instructions_top - instructions_height
    qr_height = 220

    logo_url = @exhibit.attendance.event.logo_url
    unless logo_url.blank?
      pdf.image URI.parse(logo_url).open,
                position: :center, vposition: :top, width: width * 0.9
    else
      pdf.text @exhibit.event_title, align: :center, style: :bold, size: 14
    end

    pdf.float do
      pdf.bounding_box([0, qr_top], width: width, height: qr_height) do
        pdf.stroke_bounds if @stroke_bounds
        pdf.image StringIO.new(qr_png.to_datastream.to_s), position: :center, fit: [width, qr_height]
      end
    end

    pdf.float do
      pdf.move_cursor_to 2.mm
      pdf.text @url, align: :right, size: 5
    end

    pdf.float do
      pdf.bounding_box([0, instructions_top], width: width, height: instructions_height) do
        pdf.stroke_bounds if @stroke_bounds
        current_locale = I18n.locale
        [:de, :en].each do |locale|
          I18n.locale = locale
          pdf.move_down 1.mm
          pdf.text I18n.t('voting_poster_intro'), align: :center, style: :bold
          pdf.text I18n.t('voting_poster_instruction'), align: :center
        end
        I18n.locale = current_locale
      end
    end

    pdf.float do
      pdf.bounding_box([0, name_top], width: width, height: name_height) do
        pdf.stroke_bounds if @stroke_bounds
      end
      pdf.text_box "#{@exhibit.name}" +
                     "#{'<br/><font size=\'12\'> (' + @exhibit.installation.name + ')</font>' if @exhibit.installation}" +
                     "#{'<br/><font size=\'10\'> (Gemeinschaftsprojekt / Collab)</font>' if @exhibit.is_collab?}",
                   inline_format: true,
                   at: [0, name_top],
                   width: width,
                   height: name_height,
                   overflow: :shrink_to_fit,
                   style: :bold, size: 24,
                   align: :center, valign: :center
    end

    pdf.float do
      pdf.bounding_box([0, 20], width: width * 0.6, height: 20) do
        pdf.stroke_bounds if @stroke_bounds
        pdf.text @exhibit.platform_position, style: :bold, size: 18, valign: :bottom
      end
    end

    pdf.render
  end

  def qr_png
    RQRCode::QRCode.new(@url).as_png(size: 100)
  end

end
