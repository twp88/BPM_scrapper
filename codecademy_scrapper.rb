require 'HTTParty'
require 'mechanize'

class CodecademyScrapper
  def initialize(user_name, password, target_user)
    @target_user = target_user
    @user_name = user_name
    @password = password
    @agent = Mechanize.new
  end

  def call
    sign_in_as_tom
    parse_achievements
  end

  private

  def sign_in_as_tom
    login = @agent.get('https://www.codecademy.com/')
    login_form = login.forms[1]
    username_field = login_form.field_with(name: 'user[login]')
    username_field.value = @user_name
    password_field = login_form.field_with(name: 'user[password]')
    password_field.value = @password
    login_form.submit
  end

  def parse_achievements
    page = @agent
           .get("https://www.codecademy.com/users/#{@target_user}/achievements")

    page.search('h5').text.include? 'Complete all units in Ruby'
  end
end
