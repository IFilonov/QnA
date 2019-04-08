$(document).on('turbolinks:load', function(){
   $('.question').on('click', '.question-edit-link', function(e) {
       e.preventDefault();
       $('#question-update-submit').show();
       $('.question-edit-link').hide();
       $('#question-body').attr("readonly", false);
       $('#question-title').attr("readonly", false);
   })
});
