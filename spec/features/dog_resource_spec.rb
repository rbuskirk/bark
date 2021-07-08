require 'rails_helper'

describe 'Dog resource', type: :feature do

  before(:each) do
    @user = FactoryBot.create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'can create a profile' do
    visit new_dog_path
    fill_in 'Name', with: 'Speck'
    fill_in 'Description', with: 'Just a dog'
    attach_file 'Image', 'spec/fixtures/images/speck.jpg'
    click_button 'Create Dog'
    expect(Dog.count).to eq(1)
  end

  it 'can edit a dog profile' do
    dog = create(:dog, user: @user)
    visit edit_dog_path(dog)
    fill_in 'Name', with: 'Speck'
    click_button 'Update Dog'
    expect(dog.reload.name).to eq('Speck')
  end

  it 'can delete a dog profile' do
    dog = create(:dog, user: @user)
    visit dog_path(dog)
    click_link "Delete #{dog.name}'s Profile"
    expect(Dog.count).to eq(0)
  end

  it 'only allows a dog profile to be edited by the owner' do
    dog = create(:dog)
    visit dog_path(dog)
    expect(page).not_to have_content("Edit #{dog.name}'s Profile")
  end

  it 'only allows a dog profile to be deleted by the owner' do
    dog = create(:dog)
    visit dog_path(dog)
    expect(page).not_to have_content("Delete #{dog.name}'s Profile")
  end

  it 'allows a dog profile to be liked' do
    dog = create(:dog)
    visit like_dog_path(dog)
    expect(dog.reload.likes).to eq(1)
    expect(page).to have_content("Dog was successfully liked.")
  end

  it 'only allows a dog profile to be liked by non-owner' do
    dog = create(:dog, user: @user)
    visit like_dog_path(dog)
    expect(dog.reload.likes).to eq(0)
    expect(page).to have_content("Dogs cannot be liked by their owners.")
  end

end
