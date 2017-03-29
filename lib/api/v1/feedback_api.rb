class API::V1::FeedbackAPI < Grape::API
  resource :feedback do
    desc "Create Feedback"
    params do
      requires :email, type: String, desc: "Email"
      requires :feedback, type: String, desc: "Content of feedback"
    end
    post "", jbuilder: "feedbacks/create" do
      feedback = Feedback.new(
        email: params[:email],
        feedback: params[:feedback],
        status: "active"
      )
      if feedback.valid?
        if feedback.save!
          @data = {
            message: "Create feedback successfully",
            feedback: feedback
          }
        else
          error!({ success: false, message: "Something error" }, 500)
        end
      else
        error!({ success: false, message: feedback.errors.full_messages }, 400)
      end
    end
  end
end
