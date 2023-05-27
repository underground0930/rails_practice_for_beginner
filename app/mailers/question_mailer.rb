class QuestionMailer < ApplicationMailer
  def question_created
    @user = params[:user]
    @question = params[:question]
    mail(to: @user.email, subject: '質問が投稿されました')
  end

  def answer_created
    @user = params[:user]
    @question = params[:question]
    mail(to: @user.email, subject: 'あなたの質問に回答がありました')
  end
end
