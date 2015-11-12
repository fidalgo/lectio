$(document).on('page:change', function() {
  $(".tags-input").select2({
    tags: true,
    width: '100%',
    tokenSeparators: [",", " "],
    ajax: {
      dataType: 'json',
      url: '/links/tags',
      data: function(params) {
        return {
          query: params.term,
          page: params.page
        };
      },
      processResults: function(data, params) {
        params.page = params.page || 1;
        return {
          results: $.map(data, function(tag) {
            return {
              id: tag.name,
              text: tag.name
            };
          }),
          pagination: {
            more: (params.page * 30) < data.total_count
          }
        };
      },
      cache: true
    }
  });
});
