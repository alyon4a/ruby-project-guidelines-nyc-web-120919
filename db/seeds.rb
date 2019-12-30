User.delete_all
Attraction.delete_all
Review.delete_all

user1 = User.create(name: "name", password: "123")
alona_user = User.create(name: "Alona", password: "123")
daniel_user = User.create(name: "Daniel", password: "123")

top_attraction = Attraction.create(name: "Top of The Rock", 
                  address: "30 Rockefeller Plaza", 
                  city: "New York", 
                  description: "Best views of the Central Park and Manhattan")

top_attraction.author_id = alona_user.id
top_attraction.save

charging_bull = Attraction.create(name: "Charging Bull", 
address: "11 Broadway", 
city: "New York", 
description: "Wall Street symbol")

charging_bull.author_id = daniel_user.id
charging_bull.save

times_square = Attraction.create(name: "Times Square", 
address: "45th str & 7th Ave", 
city: "New York", 
description: "The main square of New York")

times_square.author_id = user1.id
times_square.save

union_square = Attraction.create(name: "Union Square", 
address: "Geary & Powell str", 
city: "San Francisco", 
description: "The main square of San Francisco")

union_square.author_id = user1.id
union_square.save

Review.create(user_id: user1.id, attraction_id: top_attraction.id, rating: 4, content: "It was too high!")
Review.create(user_id: alona_user.id, attraction_id: charging_bull.id, rating: 3, content: "Too many people waiting to take a picture!")
Review.create(user_id: daniel_user.id, attraction_id: times_square.id, rating: 3, content: "Too crowded.")
