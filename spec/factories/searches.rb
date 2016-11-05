FactoryGirl.define do
  factory :search, class: ExtratorrentSearch::Search do
    search 'the big bang theory s10e06'
    initialize_with { new(search) }
  end

  factory :search_failed, class: ExtratorrentSearch::Search do
    search 'the big bang theory s10e66'
    initialize_with { new(search) }
  end
end
