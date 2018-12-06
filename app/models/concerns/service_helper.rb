module ServiceHelper
  extend ActiveSupport::Concern

  private
    attr_reader :service, :null_service

    def service_call(type)
      response = attempt_call(type)
      call_class = type.to_s.camelize.singularize.constantize
      response.map do |data|
        call_class.new(data)
      end
    end

    def attempt_call(type)
      begin
        service.get(type)
      rescue => detail
        nullify_service
        service.get(type)
      end
    end

    def nullify_service
      @_service = null_service
    end
end
