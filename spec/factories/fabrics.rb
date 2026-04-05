FactoryBot.define do
  factory :fabric do
    name { "Italian Wool" }
    price_cents { 15000 }
    quality_grade { :standard }

    trait :premium do
      name { "Premium Cashmere" }
      price_cents { 30000 }
      quality_grade { :super_150s }
    end
  end
end
