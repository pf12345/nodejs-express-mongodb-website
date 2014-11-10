
/**
 * 端口配置
 * @type {number}
 */
exports.port = 80;

/**
 * 日志地址
 * @type {string}
 */
exports.logPath = {
    emailLog: '../log/emailLog',
    errorLog: '../log/errorLog'
};

/**
 *数据库信息
 * @type {{cookieSecret: string, db: string, host: string}}
 */
exports.dbInfo = {
    cookieSecret:'pengfeng',
    db: 'carSchool',
    host: 'localhost'
};