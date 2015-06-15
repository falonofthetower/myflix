comedies = Category.create name: "Comedies"
dramas = Category.create name: "Dramas"

family_guy = Video.create title: "Family Guy", 
                          description: "In a wacky Rhode Island town, \
                          a dysfunctional family strive to cope with everyday \
                          life as they are thrown from one crazy scenario \
                          to another.",
                          small_cover: "family_guy.jpg",
                          large_cover: "family_guy_large.jpg",
                          category: comedies

7.times { Video.create title: "Monk", 
                       description: "Adrian Monk is a brilliant San Francisco \
                       detective, whose obsessive compulsive disorder just \
                       happens to get in the way.",
                       small_cover: "monk.jpg",
                       large_cover: "monk_large.jpg",
                       category: dramas }

2.times { Video.create title: "South Park", 
                       description: "Follows the misadventures of four \
                       irreverent grade-schoolers in the quiet, dysfunctional \
                       town of South Park, Colorado.",
                       small_cover: "south_park.jpg",
                       large_cover: "south_park_large.jpg",
                       category: comedies }

2.times { Video.create title: "Futurama", 
                       description: "Fry, a pizza guy is accidentally frozen \
                       in 1999 and thawed out New Year's Eve 2999.",
                       small_cover: "futurama.jpg",
                       large_cover: "futurama_large.jpg",
                       category: comedies }

darth_vader = User.create(
  full_name: "James Earl Jones",
  password: "I am your father",
  email: "anakin@deathstar.com",
  admin: false
)

User.create(
  full_name: "Palpatine",
  password: "Imortallity",
  email: "emperor@empire.com",
  admin: true
)

Review.create(
  user: darth_vader,
  video: family_guy,
  rating: 5,
  content: "Epic!!!"
)
Review.create(
  user: darth_vader,
  video: family_guy,
  rating: 3,
  content: "This is a rotten show"
)

