require 'rails_helper'

RSpec.describe '質問から回答までの一連の流れ', type: :system do
  let!(:user) { create(:user)}
  it '質問から回答までの一連の流れが正しく行われること' do
    visit '/login'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'

    click_on '質問作成'
    expect(current_path).to eq '/questions/new'

    expect {
      fill_in 'タイトル', with: 'form_withってなんですか'
      fill_in '質問内容', with: 'form_withが意味わかりません'
      click_on '質問する'
    }.to change { Question.count }.by(1)

    question = Question.last
    expect(current_path).to eq "/questions/#{question.id}"
    expect(page).to have_content '質問を作成しました'
    expect(page).to have_content 'form_withってなんですか'
    expect(page).to have_content 'form_withが意味わかりません'

    within '#question-area' do
      click_on '編集'
    end

    expect(current_path).to eq "/questions/#{question.id}/edit"
    fill_in 'タイトル', with: 'link_toってなんですか'
    fill_in '質問内容', with: 'link_toが意味わかりません'
    click_on '更新する'
    expect(current_path).to eq "/questions/#{question.id}"
    expect(page).to have_content '質問を更新しました'
    expect(page).to have_content 'link_toってなんですか'
    expect(page).to have_content 'link_toが意味わかりません'

    fill_in '回答内容', with: 'Railsガイドを見ましょう'
    click_on '回答する'
    expect(page).to have_content '回答しました'

    answer = Answer.last
    within "#answer_#{answer.id}" do
      expect(page).to have_content 'Railsガイドを見ましょう'
      page.accept_confirm { click_on '削除' }
    end
    expect(page).to have_content '回答を削除しました'
    expect(page).not_to have_content 'Railsガイドを見ましょう'
  end
end
