class Public::SearchesController < ApplicationController
  def search
    @word = params[:word]
    @groups = Group.looks(params[:search], params[:word])
  end
end
