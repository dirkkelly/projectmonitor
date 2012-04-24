FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    feed_url { "http://localhost:8111/bar.xml" }
  end
end
