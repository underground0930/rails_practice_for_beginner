class AnswersController < ApplicationController
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create
    @answer = current_user.answers.build(answer_params.merge(question_id: params[:question_id]))
    if @answer.save
      unless current_user.mine?(@answer.question)
        QuestionMailer.with(user: @answer.question.user, question: @answer.question).answer_created.deliver_later
      end

      User.related_to_question(@answer.question).distinct.each do |user|
        next if user.id == current_user.id || user.mine?(@answer.question)

        AnswerMailer.with(user: user, question: @answer.question).answer_created.deliver_later
      end
      redirect_to question_path(params[:question_id]), success: '回答しました'
    else
      @question = @answer.question
      flash.now[:danger] = '回答の作成に失敗しました'
      render 'questions/show'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy!
    redirect_to question_path(params[:question_id]), success: '回答を削除しました'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
