Fabricator(:video) do
  title { Faker::Lorem.words(2).join(" ") }
  description { Faker::Lorem.words(10).join(" ") }
  small_cover { %w(monk family_guy futurama).sample }
  large_cover { %w(monk_large family_guy_large futurama_large).sample }
end
