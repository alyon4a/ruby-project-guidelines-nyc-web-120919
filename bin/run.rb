require_relative '../config/environment'

prompt = TTY::Prompt.new
MenuController.new(prompt).main_menu

0