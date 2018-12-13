class TutorialFacade < SimpleDelegator
  def initialize(tutorial, video_id = nil)
    super(tutorial)
    @video_id = video_id
  end

  def current_video
    return Video.new if videos.empty?
    if @video_id
      videos.find(@video_id)
    else
      videos.first
    end
  end

  def next_video
    return Video.new if videos.empty?
    videos[current_video_index + 1] || current_video
  end

  def play_next_video?
    !(current_video.position >= maximum_video_position)
  end

  private

  def current_video_index
    videos.index(current_video)
  end

  def maximum_video_position
    return 0 if videos.empty?
    videos.max_by { |video| video.position }.position
  end
end
