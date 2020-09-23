/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明:
 **/

/**
 * 采用面向对象的方式编写js
 * @type {{register: {checkUserID: users.register.checkUserID, checkPassword: users.register.checkPassword, checkEmail: users.register.checkEmail}, loginIn: {checkUserInfo: users.loginIn.checkUserInfo}}}
 */
var users = {
    /**
     * 注册
     */
    register: {
        checkUserID: function () {
            return true;
        },
        checkPassword: function () {
            return true;
        },
        checkEmail: function () {

        }
    },

    //登录
    loginIn: {
        checkUserInfo: function () {
            return true;
        }
    },
    //注销
    loginOut: {
        redirectURL: function (url) {
            window.location.href = url;
        }
    }
};

var m = users.loginIn.checkUserInfo();