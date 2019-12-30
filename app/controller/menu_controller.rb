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
        name = @prompt.ask('Enter your name: ')
        username = @prompt.ask('Enter a username: ')
        while(User.find_by_username(username))
            username = @prompt.ask('Username already exists please enter another username: ')
        end
        password = @prompt.mask('Enter a password: ')
        User.create(name: name, username: username, password: password)
    end

end