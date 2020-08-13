$(document).on('turbolinks:load', function(){
  $('form').on('click', '.remove_fields', function(event){
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    event.preventDefault();
  });

  $('form').on('click', '.add_fields', function(event){
    approver_index = Number($(this).parent().find('.approver_index:last').text()) + 1

    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();

    $(this).parent().find('.approver_index:last').text(approver_index);

    });
  });
