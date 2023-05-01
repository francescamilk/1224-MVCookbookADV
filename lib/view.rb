class View
    def display_recipes(recipes)
        recipes.each_with_index do |recipe, i|
            box = recipe.completed ? "[X]" : "[ ]"
            puts "#{i + 1}. #{box} #{recipe.name} #{'*' * recipe.rating}"
        end
    end

    def ask_for(thing)
        puts "What's the #{thing}?"
        gets.chomp
    end
end
