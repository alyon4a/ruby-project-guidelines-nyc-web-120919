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
            menu.choice "View top 3 attractions", -> { top_3_menu }
            menu.choice "Create a new attraction", -> { new_attraction_menu }
            menu.choice "My attractions", -> { my_attractions_menu }
            menu.choice "My reviews", -> { my_reviews_menu }
            menu.choice "Search by...", -> { search_menu }
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

    def top_3_menu
        attractions = get_top_3_attraction
        rendered_table = create_attraction_table(attractions[0], attractions[1])
        @prompt.select("Select an attraction") do |menu|
            rendered_table.each_with_index do |row, index|
                if index > 2 && index < rendered_table.length - 1
                    menu.choice row, -> { select_attraction_menu(attractions[0][index - 3]) }
                else
                    menu.choice row, -> { puts "need something here" }, disabled: " "
                end
            end
            menu.choice "Go back", -> { first_menu }
        end
    end

    def get_top_3_attraction
        result = []
        attractions = Review.group(:attraction_id).average("rating").sort_by{ |_, v| -v }.first(3).to_h
        attractions.keys.each do |id|
            result.push(Attraction.find(id))
        end
        return [result, attractions.values]
    end

    def create_attraction_table(attractions, values)
        table = TTY::Table.new ['Attraction', 'City', 'Author', 'Rating'], []
        attractions.each_with_index do |attraction, index|
            author = User.find(attraction.author_id)
            table << [attraction.name, attraction.city, "#{author.name}(#{author.username})", values[index]]
        end
        return table.render(:ascii, alignments: [:left, :center]).split("\n")
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
        rendered_table = create_review_table(@user.reviews)
        
        @prompt.select("Select a review") do |menu|
            rendered_table.each_with_index do |row, index|
                if index > 2 && index < rendered_table.length - 1
                    menu.choice row, -> { review_selected(@user.reviews[index - 3]) }
                else
                    menu.choice row, -> { puts "need something here" }, disabled: " "
                end
            end
            menu.choice "Go back", -> { first_menu }
        end
    end

    def create_review_table(reviews)
        table = TTY::Table.new ['Attraction', 'City', 'Rating', 'Review'], []
        reviews.each do |review|
            table << [review.attraction.name, review.attraction.city, review.rating, review.content]
        end
        return table.render(:ascii, alignments: [:left, :center]).split("\n")
    end

    def select_attraction_menu(attraction)
        puts attraction
        puts "========================"
        @prompt.ok(attraction.name)
        puts "========================"
        @prompt.warn(attraction.description)
        puts "Located at " + attraction.address + ", " + attraction.city
        
        @prompt.select("What would you like to do for #{attraction.name}?") do |menu|
            menu.choice "View all reviews", -> { view_all_reviews(attraction) }
            menu.choice "Write a review", -> { write_review(attraction) }
            menu.choice "Go Back", -> { first_menu }
            menu.choice "Exit", -> { exit_menu }
        end
    end

    def view_all_reviews(attraction)
        puts create_review_table(attraction.reviews)
        first_menu
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
        @user.reviews.reload
        first_menu
    end

    def update_review(old_review)
        puts "Edit Review for #{old_review.attraction.name}"
        review = @prompt.collect do
            key(:rating).ask("Enter new rating 1 to 5")
            key(:content).ask("Tell us your new impression of this attraction?")
        end
        old_review.rating = review[:rating]
        old_review.content = review[:content]
        old_review.save
        first_menu
    end

    def delete_review(review)
        @user.reviews.delete(review)
        first_menu
    end

    def review_selected(review)
        @prompt.select("What would you like to do for your review of #{review.attraction.name}?") do |menu|
            menu.choice "Edit this review", -> { update_review(review) } 
            menu.choice "Delete this review", -> { delete_review(review) } 
            menu.choice "Go Back", -> { first_menu }
        end
    end

    def search_menu
        @prompt.select("") do |menu|
            menu.choice "Find all reviews by a user", -> { reviews_by_user }
            menu.choice "Find all attractions created by a user", -> { attractions_by_user }
            menu.choice "Go Back", -> { first_menu }
        end
    end

    def reviews_by_user
        author = find_a_user
        puts create_review_table(author.reviews)
        first_menu
    end

    def attractions_by_user
        user = find_a_user
        attractions_menu(author_id: user.id)
    end

    def find_a_user
        username = @prompt.ask("What's the username for the author of the attractions?")
        author = User.find_by(username: username)
        if author == nil
            puts "User not found, here are some usernames:"
            User.all.each{|user| puts user.username}
            find_a_user
        else 
            author
        end
    end

    def exit_menu
        puts "Bye, have a good day!"
    end
end