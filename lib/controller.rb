require "open-uri"
require "nokogiri"
require_relative "view"

class Controller
    def initialize(cookbook)
        @cookbook = cookbook
        @view     = View.new
    end

    def list
        display()
    end

    def add
        name = @view.ask_for("name")
        description = @view.ask_for("description")
        rating = @view.ask_for("rating").to_i
        prep_time = @view.ask_for("prep time").to_i

        recipe = Recipe.new(name, description, rating, false, prep_time)
        @cookbook.add(recipe)

        display()
    end

    def remove
        display()

        index = @view.ask_for("index").to_i - 1
        @cookbook.remove(index)

        display()
    end

    def import
        # Ask a user for a keyword to search (View)
        keyword = @view.ask_for("keyword")

        # Make an HTTP request to the recipe’s website with our keyword
        url = "https://www.allrecipes.com/search?q=#{keyword}"
        raw_doc = URI.open(url).read
        doc = Nokogiri::HTML.parse(raw_doc)

        # Parse the HTML document to extract the first 5 recipes suggested and store them in an Array
        results = []
        doc.search(".mntl-card-list-items").first(10).each do |element|
            next if element.search(".icon-star").count == 0

            # scrape the name from the card ( |element| )
            name = element.search(".card__title-text").text.strip

            # scrape the url for the details page ( |element| )
            details_url = element.attribute("href").value
            # parse the url of the details page
            raw_details = URI.open(details_url).read
            details_doc = Nokogiri::HTML.parse(raw_details)

            # scrape the description from the details page
            description = details_doc.search(".type--dog.article-subheading").text.strip
            rating = details_doc.search("#mntl-recipe-review-bar__rating_1-0").text.strip
            rating = rating.to_f.round
            prep_t = details_doc.search(".mntl-recipe-details__value").text.strip.to_i

            results << Recipe.new(name, description, rating, false, prep_t)
        end

        # Display them in an indexed list
        @view.display_recipes(results.first(5))
        # Ask the user which recipe they want to import (ask for an index)
        index = @view.ask_for("index").to_i - 1
        recipe = results[index]

        # Add it to the Cookbook
        @cookbook.add(recipe)
    end

    def mark
        # display all recipes
        display()
        # ask index of the one to mark
        index = @view.ask_for("index").to_i - 1

        # pass index to the cookbook -> mark the recipe
        @cookbook.update_mark(index)
    end

    private

    def display
        recipes = @cookbook.all
        @view.display_recipes(recipes)
    end
end
