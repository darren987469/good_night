module API
  module V1
    class SleepAPI < Grape::API
      helpers Helper::SharedParams

      resource :sleeps do
        before { authenticate_user! }

        desc 'Get sleeps of the user' do
          success Entity::V1::PaginatedSleep
        end
        params do
          use :pagination
        end
        get do
          sleeps = current_user.sleeps.order(slept_at: :desc)
          paginate sleeps, with: Entity::V1::PaginatedSleep
        end

        desc 'Create sleep' do
          success Entity::V1::Sleep
        end
        params do
          requires :slept_at, type: DateTime
          optional :waked_at, type: DateTime
        end
        post do
          sleep = current_user.sleeps.new(declared(params))
          if sleep.save
            present sleep, with: Entity::V1::Sleep
          else
            error!(sleep.errors.full_messages, 400)
          end
        end

        desc 'Update sleep' do
          success Entity::V1::Sleep
        end
        params do
          optional :slept_at, type: DateTime
          optional :waked_at, type: DateTime
          at_least_one_of :slept_at, :waked_at
        end
        patch ':id' do
          sleep = current_user.sleeps.find(params[:id])
          attributes = declared(params).reject { |_key, val| val.nil? }
          if sleep.update(attributes)
            present sleep, with: Entity::V1::Sleep
          else
            error!(sleep.errors.full_messages, 400)
          end
        end
      end
    end
  end
end
