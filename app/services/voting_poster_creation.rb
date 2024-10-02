# frozen_string_literal: true

class VotingPosterCreation < ApplicationService
  require 'prawn'

  def initialize(url)
    @url = url
  end

  def call
    qr_png = RQRCode::QRCode.new(@url).as_png
    qr_png
  end

end
