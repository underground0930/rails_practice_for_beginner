require 'rails_helper'

RSpec.describe 'サインアップ, サインイン', type: :system do

  describe 'サインアップ' do
    it 'サインアップができること' do
      expect {
        visit '/users/new'
        fill_in '名前', with: 'dyson'
        fill_in 'メールアドレス', with: 'dyson@example.com'
        fill_in 'パスワード', with: '12345678'
        fill_in 'パスワード確認', with: '12345678'
        click_on '登録する'
      }.to change { User.count }.by(1)
      expect(current_path).to eq '/questions'
      expect(page).to have_content 'サインアップが完了しました'
    end
  end

  describe 'サインイン' do
    let!(:user) { create(:user)}
    it 'サインインができること' do
      visit '/login'
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
      expect(current_path).to eq '/questions'
      expect(page).to have_content 'ログインしました'
    end
  end
end
