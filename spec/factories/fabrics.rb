FactoryBot.define do
  factory :fabric do
    sequence(:name) { |n| "Fabric #{n}" }
    price_cents { 15_000 }
    currency { "USD" }
    quality_grade { :standard }

    trait :high_value do
      price_cents { 30_000 }
      quality_grade { :elite }
    end
  end
end
