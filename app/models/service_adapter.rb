class ServiceAdapter
  private
    attr_reader :service, :null_service

    def service_call(type, call_class)
      response = attempt_call(type)
      response.map do |data|
        call_class.new(data)
      end
    end

    def attempt_call(type)
      begin
        service.get(type)
      rescue BadCredentials
        nullify_service
        service.get(type)
      end
    end

    def nullify_service
      @_service = null_service
    end
end
