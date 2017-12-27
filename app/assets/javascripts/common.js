$(document).ready(function () {
    //模态框的关闭清除
    $('body').on('hidden.bs.modal', '.modal', function () {
        $(this).remove();
    });

    //会话超时处理
    $.ajaxSetup({
        // async: false,
        complete : function(xhr, textStatus) {
            if (xhr.getResponseHeader('sessionstatus') == 'timeout') {
                window.location.href = '/';
            }
        }
    });
});

//页面提示信息
function page_notice(msg) {
    var notice = $('#notice');
    var $div = $('<div></div>');
    $div.append(msg);
    $div.find('.alert').each(function () {
        (function (it) {
            it.appendTo(notice).hide().slideDown(function () {
                var close_page_notice = function () {
                    it.slideUp(function() {
                        it.remove();
                    });
                    clearInterval(notice_timer);
                };
                var notice_timer = setInterval(function () {
                    close_page_notice();
                }, 5000);
                it.find('button.close').click(function () {
                    close_page_notice();
                });
            });

        })($(this));
    });
}

function tips(title, msg, style, callback) {

    var modal = $('<div class="modal fade"  tabindex="-1" role="dialog" aria-labelledby="tipModal">'
        + '<div class="modal-dialog modal-sm" role="document">'
        + '<div class="modal-content">'
        + '<div class="modal-header">'
        + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
        + '<h4 class="modal-title" id="myModalLabel">'+ title + '</h4>'
        + '</div>'
        + '<div class="modal-body">'
        + '<div class="alert alert-' + style + '" role="alert">' + msg + '</div>'
        + '</div>'
        + '<div class="modal-footer">'
        + '<button type="button" class="btn btn-default" data-dismiss="modal" name="cancel">取消</button>'
        + '<button type="button" class="btn btn-primary" data-dismiss="modal" name="sure">确定</button>'
        + '</div>'
        + '</div>'
        + '</div>'
        + '</div>');
    modal.modal().find('button[name="sure"]').click(function () {
        if (callback) {
            callback();
        }
    });
}

//图片预览
function preview_img(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $($(input).attr('data-target'))
                .attr('src', e.target.result);
        };

        reader.readAsDataURL(input.files[0]);
    }
}
