FactoryBot.define do
  factory :fabric do
    name { "#{Faker::Commerce.product_name} #{Faker::Number.number(digits: 3)}s" }
    price_cents { 15000 }
    currency { "USD" }
    quality_grade { Fabric.quality_grades.keys.sample }
  end
end