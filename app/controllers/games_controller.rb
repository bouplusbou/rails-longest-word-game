require 'pry-byebug'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def english?(attempt)
    user_serialized = open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    user = JSON.parse(user_serialized)
    if user["found"] == false
      return false
    else
      true
    end
  end

  def in_the_grid?(grid, attempt)
    hash_grid = {}
    grid.each { |letter| hash_grid[letter] = grid.count(letter) }
    hash_attempt = {}
    attempt.upcase.split(//).each { |letter| hash_attempt[letter] = attempt.upcase.split(//).count(letter) }
    hash_attempt.each do |key, _value|
      if hash_grid[key].nil? || hash_attempt[key] > hash_grid[key]
        return false
      end
    end
    return true
  end

  def run_game(attempt, grid)
    if english?(attempt)
      if in_the_grid?(grid, attempt)
        @result = "valid"
        # { message: "Well done !", score: ((attempt.length / time) * 1000).round(0), time: time }
      else
        @result = "grid"
        # { message: "This word is not in the grid", score: 0, time: time }
      end
    else
      @result = "english"
      # { message: "Sorry, this is not an english word", score: 0, time: time }
    end
  end

  def score
    # binding.pry
    @grid = params[:letters].split(" ")
    @attempt = params[:answer]
    run_game(@attempt, @grid)
  end
end
