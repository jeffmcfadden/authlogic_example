class Notifier < ActionMailer::Base

  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "Binary Logic Notifier <noreply@binarylogic.com>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.persistence_token)
  end

  def activation_confirmation(user)
    subject       "Activation Complete"
    from          "Binary Logic Notifier <noreply@binarylogic.com>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end
end