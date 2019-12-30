class MenuController

    def initialize(prompt)
        @prompt = prompt
    end

    def main_menu
        user_input = @prompt.select("Welcome") do |menu|
            menu.choice 'Login', -> {login}
            menu.choice 'Create Account', -> {create_account}
            menu.choice 'Exit', -> {}
        end
    end

    def login
        puts "login"
    end

    def create_account
        puts "create"
    end

end