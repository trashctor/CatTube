class Api::LikesController < ApplicationController
	def index
		raw_likes = Video.find(params[:video_id]).likes

		# only return the aggregate likes
		@likes = {up: Like.up_total(raw_likes), down: Like.down_total(raw_likes)}
		render :index
	end

	def create
		# check if the current user already liked the video in the past
		target_video_id = params[:like][:video_id]
		previous_like = current_user.likes.find_by(video_id: target_video_id)

		if previous_like
			previous_like.update!(value: params[:like][:value])
			@like = previous_like
		else
			@like = current_user.like.create!(like_params)
		end

		render :show
	end

private



	def like_params
		params.require(:like).permit(:value, :video_id)
	end
end