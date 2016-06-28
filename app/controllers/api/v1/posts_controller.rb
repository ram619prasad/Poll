class Api::V1::PostsController < ApplicationController


	swagger_controller :posts, "Post Management"

  swagger_api :index do
    summary "Fetches all User items"
    notes "This lists all the active users"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end
  def index
  	@posts = Post.all
  end


  swagger_api :show do
    summary "Fetches all User items"
    notes "This lists all the active users"
    param :path, :id, :integer, :optional, "User Id"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end
  def show
    p '111'
    p params
  	@post = Post.find(params[:id])
  end
end
