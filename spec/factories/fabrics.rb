FactoryBot.define do
  factory :fabric do
    name { "#{Faker::Commerce.product_name} #{Faker::Number.number(digits: 3)}s" }
    price_cents { 15000 }
    currency { "USD" }
    quality_grade { [ :standard, :super_100s, :super_120s, :super_150s ].sample }
  end
end
