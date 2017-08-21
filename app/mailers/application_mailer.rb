class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@kwakker.herokuapp.com'
  layout 'mailer'
end
