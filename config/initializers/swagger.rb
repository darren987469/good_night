GrapeSwaggerRails.options.url = '/api/swagger_doc.json'
GrapeSwaggerRails.options.before_action do
  # TODO: add devise and uncomment the following line
  # authenticate_user!
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
