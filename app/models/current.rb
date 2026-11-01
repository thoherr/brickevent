# frozen_string_literal: true

# Per-request attributes, reset by Rails after every request.
class Current < ActiveSupport::CurrentAttributes
  # Host (and port) the current request came in on, used for links in mails.
  attribute :host_with_port
end
