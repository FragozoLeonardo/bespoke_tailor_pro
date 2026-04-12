module Fabrics
  class CreateService
    def initialize(params)
      @params = params
    end

    def call
      result = ApplicationResult.new(success: false, errors: [ "Unexpected processing error" ])

      begin
        fabric = Fabric.new(@params)

        Fabric.transaction do
          if fabric.save
            result = ApplicationResult.new(success: true, data: fabric)
          else

            result = ApplicationResult.new(success: false, data: fabric, errors: fabric.errors.full_messages)
            raise ActiveRecord::Rollback
          end
        end
      rescue ActiveRecord::RecordNotUnique
        result = ApplicationResult.new(success: false, errors: [ "This fabric is already registered in the system." ])
      rescue ActiveRecord::QueryCanceled, ActiveRecord::ConnectionFailed => e
        result = ApplicationResult.new(success: false, errors: [ "Infrastructure failure: #{e.message}" ])
      rescue => e
        result = ApplicationResult.new(success: false, errors: [ e.message ])
      end

      result
    end
  end
end
