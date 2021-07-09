class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    if current_user.author_of?(@attachment.record)
      @attachment.purge
    else
      flash[:notice] = 'You must be the author to delete the attachment'
    end
  end
end
