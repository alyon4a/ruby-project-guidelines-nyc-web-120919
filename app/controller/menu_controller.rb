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


    def first_menu
        @prompt.select("") do |menu|
            menu.choice "View all attractions", -> { attractions_menu }
            menu.choice "View all cities", -> { cities_menu }
            menu.choice "Create a new attraction", -> { new_attraction_menu }
            menu.choice "My attractions", -> { my_attractions_menu }
            menu.choice "My reviews", -> { my_reviews_menu }
            menu.choice "Exit", -> { exit_menu }
        end
    end

    def attractions_menu
        puts "Attractions!"
    end

    def cities_menu
        puts "Cities!"
    end

    def new_attraction_menu
        puts "New Attraction!"
    end

    def my_attractions_menu
        puts "My Attractions!"
    end

    def my_reviews_menu
        puts "My reviews!"
    end

    def exit_menu
        "Bye, have a good day!"
    end
end