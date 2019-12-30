class MenuController

    def initialize(prompt)
        @prompt = prompt
    end

    def main_menu
        user_input = @prompt.select("Welcome") do |menu|
            menu.choice 'Login', 1
            menu.choice 'Create Account', 2
            menu.choice 'Exit', 3
        end
        if user_input == 1
            login
        elsif user_input == 2
            createAccount
        end
    end

    def login
        puts "login"
    end

    def createAccount
        puts "create"
    end

end