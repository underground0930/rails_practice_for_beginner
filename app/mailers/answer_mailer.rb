class AnswerMailer < ApplicationMailer
  def answer_created
    @user = params[:user]
    @question = params[:question]
    mail(to: @user.email, subject: 'あなたが回答したことのある質問に新しい回答がつきました')
  end
end
