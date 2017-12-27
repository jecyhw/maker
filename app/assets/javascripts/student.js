$(document).ready(function () {
    (function () {
        var current_item = $('.list-group-item-click');
        var breadcrumb = $('.breadcrumb');
        var container = $('#content-container');
        makePathByItem(current_item);
        show(current_item, container);
        $(".list-group-item").click(function () {
            var $it = $(this);
            if ($it.text() != current_item.text()) {
                $it.addClass('list-group-item-click');
                current_item.removeClass('list-group-item-click');
                current_item = $it;
                makePathByItem(current_item);
                show(current_item, container);
            }
            return false;
        });

        function makePathByItem($it) {
            breadcrumb.children().remove();
            var paths = [];
            var parents = $it.parents('.panel').find('.panel-heading');
            if (parents.length > 0) {
                paths.push(parents.html())
            }

            paths.push($it.html())

            for (var index in paths) {
                breadcrumb.append('<li><span>' + paths[index] + '</span></li>');
            }
        }
    })()
});

//student的列表显示
function show($it, $container) {
    $.get(
        $it.attr('href'),
        { method: $it.attr('data-method')},
        function (data) {
            var modal =  $(data.result);
            $container.html(modal);
            var callback = function(data) {
                if (data.message) {//更新信息
                    modal = $(data.content);
                    $container.html(modal);
                    page_notice(data.message);
                    //container内容重新加载了,需要重新设置事件
                    handel_file(modal, callback);
                } else {//更新头像
                    page_notice(data);
                }
            };

            handel_file(modal, function(data) {
                callback(data);
            });

        },
        'json'
    );
}


function handel_file(modal, callback) {
    var iframe = modal.find('iframe');
    if (iframe.length > 0) {//添加有图片上传时需要特殊处理,来实现页面无刷新获取添加状态
        modal.find("#photo-choose").click(function() {
            modal.find($(this).attr('data-target')).click();
        });
        iframe.on('load', function () {
            var iframe_body = $(this).contents().find("body");
            var iframe_body_html = iframe_body.html();
            if (!(/^\s*$/.test(iframe_body_html))) {
                var data = $.parseJSON(iframe_body_html);
                iframe_body.html('');
                if (data.status == 0) {
                    if (callback) {
                        callback(data.result);
                    } else {
                        page_notice(data.result);
                    }
                } else {
                    page_notice(data.result);
                }
            }
        });
    }
}
