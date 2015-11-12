// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require select2
//= require_tree .

// Initialise all popover's
options = {
  'html': true
};
$(function() {
  $('[data-toggle="popover"]').popover(options);
});

$(document).ready(function() {
  $("#tags-input").select2({
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
