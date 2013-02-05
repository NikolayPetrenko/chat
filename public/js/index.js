var message = {
    init: function(){
      this.realtimeMessage();
      this.ajaxSend();
    },

    ajaxSend: function(){
      $("#new-message").ajaxForm({ beforeSubmit: message.validate, success: function(){ $('textarea[name="body"]').val('') } });
    },

    validate: function(formData, jqForm, options){
        if(_(_($('textarea[name="body"]').val()).strip()).empty())
          return false;
    },

    realtimeMessage: function(){
        var socket = io.connect('http://localhost');
        socket.on('new_post', function(data){
            $(".messages").prepend('<div class="row-fluid"><div class="span3">' + new Date(data.created_at).toUTCString() + '</div><div><strong>' + data.user + ':&nbsp;</strong>' + data.body + '</div></div>');
        });
    }
}

$(document).ready(function(){
    message.init();
});