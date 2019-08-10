module Entity
  module V1
    class User < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :name, documentation: { type: String }
    end
  end
end
