class UsersMailer < ActionMailer::Base
    default :from => "CORE Board <coreboard@columbia.edu>"

    def registration_confirmation(user)
        @user = user
        mail(:to => "#{user.first_name} #{user.last_name} <#{user.email}>",
             :subject => "CORE Contacts Confirmation")
    end
 end
 