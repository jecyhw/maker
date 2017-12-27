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
                var add_delete = $('.add-delete');
                if ($it.attr('data-op') == 'false') {
                    add_delete.removeClass('show').addClass('hide');
                    breadcrumb.parent().removeClass('col-sm-8').addClass('col-sm-12');
                } else {
                    if (add_delete.hasClass('hide')) {
                        add_delete.removeClass('hide').addClass('show');
                        breadcrumb.parent().removeClass('col-sm-12').addClass('col-sm-8');
                    }
                }

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

        $("button[name='add']").click(function () {//记录添加
            var method = current_item.attr('data-method').replace('show', 'add');
            var href = current_item.attr('href');

            $.get(//注意,添加请求使用get,保存使用post
                href,
                { method: method},
                function (data) {
                    if (!data.status) {
                        var modal = $(data.result).modal();

                        //查看modal是否需要select级联 楼层,窗口添加需要级联
                        dynamic_select(href, modal);
                        handel_file(modal, function (data) {modal.modal('hide');
                            var tbody = container.find('tbody');
                            tbody.find('tr.success').removeClass('success');
                            $(data).hide().prependTo(tbody).fadeIn();
                        });
                    } else {
                        page_notice(data.result);
                    }
                },
                'json'
            );
        });

        $('body').on("click", "button[name='delete']", function () {//删除操作
            var ids = [];
            var parent_tr = $(this).parents('tr');
            if (parent_tr.length > 0) { //单条记录删除
                ids.push(parent_tr.find('input[type="checkbox"]').attr('id'));
            } else { //多条记录修改
                var checked = container.find('input[type="checkbox"]:checked');
                if (checked.length > 0) {
                    checked.each(function () {
                        ids.push($(this).attr('id'));
                    });
                }
            }

            if (ids.length > 0) {
                tips('警告', '相关联的食堂工作人员的权限也将被取消,确定删除吗', 'danger', function () {
                    $.post(
                        current_item.attr('href'),
                        {
                            id: ids.join('|'),
                            method: current_item.attr('data-method').replace('show', 'delete')
                        },
                        function (data) {
                            if (!data.status) {
                                for (var id in ids) {
                                    $('#' + ids[id]).parents('tr').fadeOut(function () {
                                        $(this).remove();
                                    });
                                }
                            } else {
                                tips('提示', '删除失败', 'warning');
                            }
                        },
                        'json'
                    );
                });
            }
        }).on("click", "button[name='edit']", function () {//编辑操作
            var tr = $(this).parents('tr');
            var method = current_item.attr('data-method').replace('show', 'edit');
            var href = current_item.attr('href');

            $.get(//注意,编辑请求使用get,保存使用post
                href,
                {
                    id: tr.find('input[type="checkbox"]').attr('id'),
                    method: method
                },
                function (data) {
                    var modal = $(data.result).modal();

                    //查看modal是否需要select级联 楼层,窗口修改需要级联
                    dynamic_select(href, modal);

                    handel_file(modal, function (data) {//处理带文件上传和更新
                        modal.modal('hide');
                        var tbody = container.find('tbody');
                        tbody.find('tr.success').removeClass('success');
                        $(data).hide().prependTo(tbody).fadeIn();
                    });
                },
                'json'
            );
        });

        //对列表中的记录进行反选操作
        $('button[name="unselect"]').click(function () {
            container.find('input[type="checkbox"]').each(function () {
                this.checked = !$(this).is(':checked');
            });
        });
    })()
});

//admin的列表显示
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

//select级联处理
function dynamic_select(url, modal) {
    modal.find('label[data-dynamic-select="true"]').each(function () {
        var label = $(this);
        var select_parent = label.next();
        var select_child = modal.find("#" + label.attr('data-target'));
        while (true) {
            (function(parent, child) {//闭包实现多级菜单级联
                parent.change(function () {
                    if (this.value) {
                        $.post(
                            url,
                            {
                                id: this.value,
                                method: parent.prev().attr('data-method')
                            },
                            function (data) {
                                if (data.status == 0) {//返回成功
                                    var child_prev_label = child.prev();
                                    if (data.result.length > 0) {
                                        child.html($(new Option(child_prev_label.attr('data-prompt'), '')));
                                        for (var index in data.result) {
                                            var canteen = data.result[index];
                                            child.append(new Option(canteen.name, canteen.id));
                                        }
                                    } else {
                                        child.html($(new Option(child_prev_label.attr('data-no-prompt'), '')));
                                    }
                                } else {
                                    //失败未做处理
                                }
                            },
                            'json'
                        );
                    } else {
                        child.html($(new Option(child.prev().attr('data-no-choose'), '')));
                        child.trigger('change')
                    }
                });
            })(select_parent, select_child);
            var data_target = select_child.prev().attr('data-target');
            if (typeof(data_target) == 'undefined') {
                break;
            } else {
                var select_temp = modal.find("#" + data_target);
                select_parent = select_child;
                select_child = select_temp;
            }
        }
    });
}

//带文件上传的form处理,实现无刷新文件上传
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
