class ContactsMailer < ActionMailer::Base
  default :from => "CORE Board <coreatcu@gmail.com>"

  def introduce(contact, asker)
    @contact = contact
    @asker = asker
    mail(:to => "#{contact.user.name} <#{contact.user.email}>",
         :subject => "Introduction to #{contact.first_name} #{contact.last_name}")
  end
end
