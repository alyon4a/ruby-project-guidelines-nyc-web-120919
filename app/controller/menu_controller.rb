class MenuController

    def initialize(prompt)
        @prompt = prompt
    end

    def main_menu
        user_input = @prompt.select("Welcome") do |menu|
            menu.choice 'Login', -> { login }
            menu.choice 'Create Account', -> { create_account }
            menu.choice 'Exit', -> { exit_menu }
        end
    end

    def login
        username = @prompt.ask('Enter username: ')
        password = @prompt.mask('Enter password: ')
        user = User.find_by(username: username)
        if user && user.password == password
            @user = user
            first_menu
        else
            @prompt.error("Username and password does not match")
            @prompt.select("") do |menu|
                menu.choice "Try Again", -> { login }
                menu.choice "Create Account", -> { create_account }
                menu.choice "Exit", -> { exit_menu }
            end
        end
    end

    def create_account
        name = @prompt.ask('Enter your name: ')
        username = @prompt.ask('Enter a username: ')
        while(User.find_by(username: username))
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

    def attractions_menu(arguments = nil)
        filtered_attractions = arguments == nil ? Attraction.all : Attraction.where(arguments)
        @prompt.select("Select an attraction") do |menu|
            filtered_attractions.each do |attraction| 
                menu.choice attraction.name, -> {select_attraction_menu(attraction)}
            end
            menu.choice "Go back", -> { first_menu }
        end
    end

    def cities_menu
        @prompt.select("Select a city") do |menu|
            Attraction.select(:city).distinct.each do |attraction|
                menu.choice attraction.city, -> {attractions_menu(city: attraction.city)}
            end
            menu.choice "Go back", -> { first_menu }
        end
    end

    def new_attraction_menu
        attraction = @prompt.collect do
            key(:name).ask("Enter an atttraction name")
            key(:address).ask("Enter the address of the attraction")
            key(:city).ask("Enter the city of the attraction")
            key(:description).ask("How would you describe this attraction?")
        end
        attraction[:author_id] = @user.id
        Attraction.create(attraction)
        first_menu
    end

    def my_attractions_menu
        @prompt.select("Select an attraction") do |menu|
            Attraction.where('author_id = ?', @user.id).each do |attraction|
                menu.choice attraction.name, -> {select_attraction_menu(attraction)}
            end
            menu.choice "Go back", -> { first_menu }
        end
    end

    def my_reviews_menu
        #get reviews created by the current user (display Attraction,Rating,Content)
        #select a review or "Go Back"
        #for the 1 selected review display full review and options: update, delete, go back
        puts "My reviews!"
    end

    def select_attraction_menu(attraction)
        puts "========================"
        puts attraction.name
        puts "========================"
        puts attraction.description
        puts "Located at " + attraction.address + ", " + attraction.city
        
        @prompt.select("What would you like to do for #{attraction.name}?") do |menu|
            menu.choice "View all reviews", -> {  } #helper method similar to my_reviews
            menu.choice "Write a review", -> { write_review(attraction) } #helper method to write a review
            menu.choice "Go Back", -> { first_menu }
            menu.choice "Exit", -> { exit_menu }
        end
    end

    def write_review(attraction)
        puts "New Review for #{attraction.name}"
        review = @prompt.collect do
            key(:rating).ask("Enter your rating 1 to 5")
            key(:content).ask("Tell us your impression of this attraction?")
        end
        review[:user_id] = @user.id
        review[:attraction_id] = attraction.id
        Review.create(review)
        first_menu
    end

    def exit_menu
        puts "Bye, have a good day!"
    end
end