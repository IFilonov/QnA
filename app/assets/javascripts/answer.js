$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       $('#answer-file-field').val(null);
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })
});
