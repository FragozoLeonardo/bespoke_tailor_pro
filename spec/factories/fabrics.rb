FactoryBot.define do
  factory :fabric do
    sequence(:name) { |n| "Fabric #{n}" }
    price_cents { 10000 }
    currency { "USD" }
    quality_grade { :standard }

    trait :premium do
      name { "Loro Piana Super 150s" }
      price_cents { 25000 }
      quality_grade { :elite }
    end

    trait :japanese_silk do
      name { "Kyoto Imperial Silk" }
      currency { "JPY" }
      price_cents { 500000 }
      quality_grade { :elite }
    end
  end
end
