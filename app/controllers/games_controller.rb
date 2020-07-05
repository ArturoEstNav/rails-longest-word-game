require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letters = Array.new(5) { (('A'..'Z').to_a - %w(A E I O U Y)).sample }
    vowels = Array.new(5) { %w(A E I O U Y).sample }
    @letters = (letters + vowels).shuffle
    @time = Time.now
  end

  def score
    @word = params['user_word']
    @grid = params['letters'].split
    @start_time = params['start_time']
    @end_time = Time.now

    @letter_compliance = included?(@word, @grid)
    @valid = valid_word?(@word)
    @score = compute_score(@start_time, @end_time)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def valid_word?(attempt)
    response = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    dict = JSON.parse(response.read)
    dict['found']
  end
end


