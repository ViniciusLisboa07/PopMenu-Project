class Api::ImportsController < ApplicationController
  def create
    begin
        json_data = JSON.parse(request.body.read)
        result = import_service(json_data).call
        render json: { logs: result[:logs], status: result[:status] }, status: :ok
    rescue JSON::ParserError
        render json: { error: 'Invalid JSON' }, status: :bad_request
    rescue StandardError => e
        Rails.logger.error("Import failed: #{e.message}")
        render json: { error: 'Internal server error', message: e.message }, status: :internal_server_error
    end
  end

  private

  def import_params
    params.require(:import).permit(:json_data)
  end

  def import_service(json_data)
    @import_service ||= ImportService.new(json_data)
  end
end
