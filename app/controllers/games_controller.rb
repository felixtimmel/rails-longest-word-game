require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    final_grid = []
    rand(7..10).times do
      final_grid << ('A'..'Z').to_a.sample
    end
    @letters = final_grid
  end

  def score
    @word = params[:word]
    @letter_string = params[:letters]
    @message = ''
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    language_word = open(url).read
    language = JSON.parse(language_word)
    if language['found'] == false
      @message = "Sorry but #{@word} does not seem to be a valid English word..."
    elsif in_grid(@word, @letter_string) == false
      @message = "Sorry but #{@word} can't be built out of #{@letter_string}"
    else
      @message = "Congratulations! #{@word} is a valid English word"
    end
  end

  def in_grid(attempt, grid)
    unused_grid = grid.clone
    attempt.upcase.chars.each do |letter|
      if unused_grid.include? letter
        unused_grid.chars.delete_at(unused_grid.index(letter))
      else
        return false
      end
    end
    return true
  end
  # def include?(word, letters)
  #   word.upcase.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  # end
end
