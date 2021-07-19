class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    if current_user.author_of?(@link.linkable)
      @link.destroy
      flash.now[:notice] = 'Your link successfully deleted.'
    else
      flash.now[:notice] = 'You must be the author to delete the link.'
    end
  end
end
