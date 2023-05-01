class Recipe
    def initialize(name, description, rating, completed, prep_time)
        @name        = name
        @description = description
        @rating      = rating
        @completed   = completed
        @prep_time   = prep_time
    end

    attr_reader :name, :description, :rating, :completed, :prep_time

    def mark_completed!
        @completed = true
    end
end
