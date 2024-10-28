module ErrorHandler
  extend ActiveSupport::Concern

  private

  def handle_errors
    yield
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Record not found" }, status: :not_found
  rescue RuntimeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
