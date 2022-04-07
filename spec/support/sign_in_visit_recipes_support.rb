module SignInVisitRecipesSupport
  def sign_in_visit_recipes(user)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
    expect(page).to have_content('レシピ一覧')
    visit recipes_path
  end
end