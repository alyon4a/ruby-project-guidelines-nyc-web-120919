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
        username = @prompt.ask('Enter username: ')
        password = @prompt.mask('Enter password: ')
        user = User.find_by_username(username)
        if user && user.password == password
            @user = user
            first_menu
        else
            @prompt.error("Username and password does not match")
            @prompt.select("") do |menu|
                menu.choice "Try Again", -> {login}
                menu.choice "Exit"
            end
        end
    end

    def create_account
        name = @prompt.ask('Enter your name: ')
        username = @prompt.ask('Enter a username: ')
        while(User.find_by_username(username))
            username = @prompt.ask('Username already exists please enter another username: ')
        end
        password = @prompt.mask('Enter a password: ')
        @user = User.create(name: name, username: username, password: password)
        first_menu
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
        #Select from all the attractions
        #for the one that's selected puts details about it 
        #and show choice: see all reviews or write a new review
        #add "Go back" menu
        puts "Attractions!"
    end

    def cities_menu
        #display all cities from all attractions
        #select 1 city
        #display all attractions for that city
        #Go back
        puts "Cities!"
    end

    def new_attraction_menu
        #prompt.ask
        # :name
        # :address
        # :city    
        # :description
        # Create a new Attraction
        # add current user id as :author_id
        puts "New Attraction!"
    end

    def my_attractions_menu
        #get attractions created by the current user
        #go back to first menu after displaying all the attractions
        puts "My Attractions!"
    end

    def my_reviews_menu
        #get reviews created by the current user (display Attraction,Rating,Content)
        #select a review or "Go Back"
        #for the 1 selected review display full review and options: update, delete, go back
        puts "My reviews!"
    end

    def exit_menu
        puts "Bye, have a good day!"
    end
end