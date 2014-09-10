/**
 * 工具方法
 * Created by massimo on 14-2-25.
 */

/**
 * 生成guid
 * @returns {*}
 */
exports.guid = function () {
    return guid();
}

function formatDate(date) {
    return date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
}

function formatTime(date) {
    return formatDate(date) + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
}

function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
};

function guid() {
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
        s4() + '-' + s4() + s4() + s4();
}

/**
 * 当前时间
 * @return {[type]} [description]
 */

exports.currentTime = function () {
    return formatTime(new Date());
}

/**
 * 当前日期
 * @return {[type]} [description]
 */

exports.currentDate = function () {
    return formatDate(new Date());
}