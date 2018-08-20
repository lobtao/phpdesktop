/**
 * Created by Administrator on 2017-4-24.
 */

function client(baseUrl){
    //var baseUrl = "<?=url('admin/Service/index', '', '')?>";
    var client = {
        ajax: function (func, args, dataType) {
            var _this = this;
            var def = $.Deferred();
            $.ajax({
                type: "POST",
                url: baseUrl,
                data: {f: func, p: JSON.stringify(args)},
                success: function (ret) {
                    //console.log(ret);
                    if (ret.retid == 0) {
                        if (_this.onerror) {
                            _this.onerror(ret.retmsg)
                        }
                        def.reject(ret.retmsg);
                    } else {

                        def.resolve(ret.data);
                    }
                },
                dataType: dataType
            });
            return def;
        },
        onerror: null,
        invoke: function (func, args, callback) {
            var promise = this.ajax(func, args, 'json');
            if (callback) {
                promise.then(callback);
            }
            return promise;
        },
        invokep: function (func, args, callback) {
            var promise = this.ajax(func, args, 'jsonp');
            if (callback) {
                promise.then(callback);
            }
            return promise;
        }
    };
    //全局异常处理
    client.onerror = function (err) {
        alert(err);
    };

    return client;
}