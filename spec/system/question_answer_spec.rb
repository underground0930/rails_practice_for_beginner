require 'rails_helper'

RSpec.describe '質問から回答までの一連の流れ', type: :system do
  describe '基本的な操作' do
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
        expect(page).to have_content '未解決'
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

      within '#question-area' do
        page.accept_confirm { click_on '解決済みにする' }
        expect(page).to have_content '解決済み'
      end
      expect(page).to have_content '解決済みにしました'
    end
  end

  describe 'ステータスによる質問の絞り込み' do
    let!(:user) { create(:user)}
    let!(:solved_question1) { create(:question, title: '解決済み質問1', solved: true) }
    let!(:solved_question2) { create(:question, title: '解決済み質問2', solved: true) }
    let!(:unsolved_question1) { create(:question, title: '未解決質問1') }
    let!(:unsolved_question2) { create(:question, title: '未解決質問2') }
    before do
      visit '/login'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
    end
    it '質問の「全て」「未解決」「解決済み」の絞り込みが正しく行えること' do
      visit '/questions'
      expect(page).to have_content '解決済み質問1'
      expect(page).to have_content '解決済み質問2'
      expect(page).to have_content '未解決質問1'
      expect(page).to have_content '未解決質問2'

      click_on '未解決'
      expect(page).to have_content '未解決質問1'
      expect(page).to have_content '未解決質問2'

      click_on '解決'
      expect(page).to have_content '解決済み質問1'
      expect(page).to have_content '解決済み質問2'
    end
  end

  describe 'ページング' do
    let!(:user) { create(:user)}
    let!(:questions) { create_list(:question, 30) }
    before do
      visit '/login'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
    end
    it 'ページングが実装されていること' do
      visit '/questions'
      within '.pagination' do
        expect(page).to have_content '2'
      end
    end
  end

  describe '質問, 回答時のメール通知' do
    let!(:user) { create(:user)}
    let!(:yamada) { create(:user) }
    let!(:suzuki) { create(:user) }
    let!(:sato) { create(:user) }
    before do
      visit '/login'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
    end
    it '質問があった際に全員に対して質問があった旨をメールで通知する。（ただし自分は除く）' do
      click_on '質問作成'
      expect(current_path).to eq '/questions/new'

      expect {
        fill_in 'タイトル', with: 'form_withってなんですか'
        fill_in '質問内容', with: 'form_withが意味わかりません'
        click_on '質問する'
      }.to change { Question.count }.by(1).and change { ActionMailer::Base.deliveries.size }.by(3)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).to include(yamada.email)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).to include(suzuki.email)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).to include(sato.email)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).not_to include(user.email)
    end

    it '質問に対して回答があった場合は質問者および当該質問に回答したユーザーに対してメールで通知する。（ただし自分は除く）' do
      question = create(:question, user: yamada)
      create(:answer, question: question, user: suzuki)
      visit "/questions/#{question.id}"

      expect {
        fill_in '回答内容', with: 'Railsガイドを見ましょう'
        click_on '回答する'
      }.to change { Answer.count }.by(1).and change { ActionMailer::Base.deliveries.size }.by(2)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).to include(yamada.email)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).to include(suzuki.email)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).not_to include(user.email)
      expect(ActionMailer::Base.deliveries.flat_map(&:to)).not_to include(sato.email)
    end
  end
end
