require_relative '../config/environment'

ActiveRecord::Base.logger = nil
prompt = TTY::Prompt.new
MenuController.new(prompt).main_menu

0