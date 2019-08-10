module Entity
  module V1
    class Sleep < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :slept_at, documentation: { type: DateTime }
      expose :waked_at, documentation: { type: DateTime }
    end
  end
end
