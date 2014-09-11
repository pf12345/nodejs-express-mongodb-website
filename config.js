/**
 * Created by massimo on 14-2-25.
 */

/**
 * mysql数据库配置
 */
exports.dbConfig = function () {
    return {
        host: 'localhost',
        user: 'root',
        port:3306,
        password: '',
        database: 'mockup'
    }
}

/**
 * 端口配置
 * @type {number}
 */
exports.port = 8082;