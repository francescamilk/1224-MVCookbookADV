require "csv"
require_relative "recipe"

class Cookbook
    def initialize(csv_file)
        @csv_file = csv_file
        @recipes  = []

        load_csv()
    end

    def all
        @recipes
    end

    def add(recipe)
        @recipes << recipe
        save_csv()
    end

    def remove(index)
        @recipes.delete_at(index)
        save_csv()
    end

    def update_mark(index)
        # find recipe by index
        recipe = @recipes[index]
        # update the completed status
        recipe.mark_completed!
        save_csv()
    end

    private

    def save_csv
        CSV.open(@csv_file, "wb") do |csv|
            @recipes.each do |recipe|
                csv << [recipe.name, recipe.description, recipe.rating, recipe.completed, recipe.prep_time]
            end
        end
    end

    def load_csv
        CSV.foreach(@csv_file) do |row|
            name        = row[0]
            description = row[1]
            rating      = row[2].to_i
            completed   = row[3] == "true"  
            prep_time   = row[4].to_i

            @recipes << Recipe.new(name, description, rating, completed, prep_time)
        end
    end
end
