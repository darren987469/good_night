module Entity
  module V1
    PaginatedSleepWithUser =
      Entity::V1::Pagination.paginated_entity_class(Entity::V1::SleepWithUser)
  end
end
