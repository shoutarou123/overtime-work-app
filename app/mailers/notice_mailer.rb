class NoticeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.greeting.subject
  #
  def overtime_req_notice
    @greeting = "お疲れさまです。"

    mail(to: "850123.as@gmail.com",  subject: '通知')
  end

  def overtime_report_notice
    @greeting = "お疲れさまです。"

    mail(to: "850123.as@gmail.com",  subject: '通知')
  end
end
