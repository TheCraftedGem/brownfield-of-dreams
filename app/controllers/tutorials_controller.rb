class TutorialsController < ApplicationController
  def index
    q = Tutorial.all
    q = Tutorial.tagged_with(params[:tag]) if params[:tag]
    q = q.where(classroom: false) unless current_user
    @tutorials = q.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    tutorial = Tutorial.find(params[:id])
    @facade = TutorialFacade.new(tutorial, params[:video_id])
  end
end
