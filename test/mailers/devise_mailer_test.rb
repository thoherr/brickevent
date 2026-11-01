require "test_helper"

class DeviseMailerTest < ActionMailer::TestCase
  test "links point to the host of the current request" do
    user = users(:one)

    # Devise delivers inside the request, while Current is set; render it there too
    mail = Current.set(host_with_port: "lug2.example.org") do
      DeviseMailer.confirmation_instructions(user, "token123").message
    end

    assert_match %r{https?://lug2\.example\.org/users/confirmation\?}, mail.body.encoded
  end

  test "parallel requests for different LUG domains do not share the host" do
    user = users(:one)
    hosts = %w[lug-a.example.org lug-b.example.org]

    bodies = hosts.map do |host|
      Thread.new do
        Current.set(host_with_port: host) { DeviseMailer.confirmation_instructions(user, "t").body.encoded }
      end
    end.map(&:value)

    hosts.zip(bodies).each { |host, body| assert_includes body, host }
  end

  test "without a request the configured default host is used" do
    mail = DeviseMailer.confirmation_instructions(users(:one), "token123")

    assert_match %r{https?://www\.example\.com/users/confirmation\?}, mail.body.encoded
  end
end
