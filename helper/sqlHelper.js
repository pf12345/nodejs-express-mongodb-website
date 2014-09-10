/**
 * Created by massimo on 14-2-25.
 */
var mysql = require('mysql');
var dbConfig = require('../config').dbConfig();
var logger = require('../helper/logger');

/**
 * 数据库连接池
 * @type {*}
 */
var pool = mysql.createPool(dbConfig);

/**
 * 测试数据库连接
 * @param callback
 */
exports.testConnect = function (callback) {
    pool.getConnection(function (err, connection) {
        if (err) {
            logger.log('test connect error', err);
            callback(err);
        }
        else {
            connection.query('SELECT 1+1 as result', function (err2, rows, fields) {
                connection.release();
                if (err2) {
                    logger.log('mysql执行异常', err2);
                    callback(err2);
                }
                else {
                    callback(null, rows[0].result === 2);
                }
            });
        }
    });
}

var util = require('../helper/util');

/**
 *
 * @param callback
 */
exports.generateKey = function (callback) {
    pool.getConnection(function (err, connection) {
        if (err) {
            logger.log('sql connection', err);
            callback(err);
        }
        else {
            var serialNumber = util.guid();
            var activeCount = 3;
            connection.query('INSERT INTO serialNumbers(number,remainActiveCount,addTime,state) VALUES(?,?,now(),0)', [serialNumber, activeCount], function (err2, result) {
                connection.release();
                if (err2) {
                    logger.log('插入异常', err2);
                }
                else {
                    var id = result.insertId; //自增ID
                    logger.log('生成key', id);
                    callback(null, serialNumber);
                }
            });
        }
    })
}


var activeMessage = {
    SERVER_ERROR: 'Server Error!',
    SUCCESS: 'Active Success!',
    NO_REMAIN_COUNT: 'No Remain Count!',
    INVALID_KEY: 'Invalid Key!'
}

/**
 * 激活
 * @param key
 * @param mac
 * @param callback
 */
exports.active = function (key, mac, callback) {
    pool.getConnection(function (err, connection) {
        if (err) {
            logger.log('sql connection', err);
            throw err;
        }
        else {
            connection.query('select * from activerecord where mac=? and number=? LIMIT 1;', [mac, key], function (err, result) {
                if (err) {
                    logger.log('active select error');
                    throw err;
                }
                else {
                    if (result[0]) { //该计算机已经激活过了
                        callback(null, activeMessage.SUCCESS);
                    }
                    else {
                        connection.query('select remainActiveCount from serialnumbers where number=? and state=0 LIMIT 1;', [key], function (err, result) {
                            if (err) {
                                logger.log('get serialnumber error', err);
                                throw err;
                            }
                            else {
                                if (result[0]) { //如果存在这个key
                                    var count = result[0].remainActiveCount;
                                    if (count > 0) {
                                        //激活，扣除次数，添加记录
                                        connection.beginTransaction(function (err) {
                                            if (err) {
                                                logger.log('active begin transaction error', err);
                                                throw err;
                                            }
                                            else {
                                                connection.query('INSERT INTO activerecord(number,mac,addTime,state) values (?,?,now(),0);', [key, mac], function (err, result) {
                                                    if (err || result.affectedRows <= 0) {
                                                        connection.rollback(function () {
                                                            logger.log('active insert error', err);
                                                            throw err;
                                                        });
                                                    }
                                                    else {
                                                        connection.query('UPDATE serialnumbers set remainActiveCount=remainActiveCount-1 where number=? and remainActiveCount>0 and state=0;', [key], function (err, result) {
                                                            if (err || result.affectedRows <= 0) {
                                                                connection.rollback(function () {
                                                                    logger.log('active insert error', err);
                                                                    throw err;
                                                                })
                                                            }
                                                            else {
                                                                connection.commit(function () {
                                                                    callback(null, activeMessage.SUCCESS);
                                                                });
                                                            }
                                                        })
                                                    }

                                                });
                                            }
                                        });
                                    }
                                    else {
                                        callback(new Error('no remian active count'), activeMessage.NO_REMAIN_COUNT); //没有激活次数了
                                    }
                                }
                                else {
                                    callback(new Error('invalid key'), activeMessage.INVALID_KEY); //无效的key
                                }
                            }
                        })
                    }
                }
            });
        }
    });
}

/**
 * 构造安全的激活sql
 * @param key
 * @param mac
 * @returns {string}
 */
function getActiveSql(key, mac) {
    var sql = 'IF EXISTS ( SELECT * FROM serialnumbers WHERE number =@number AND remainActiveCount > 0 AND state = 0    )    BEGIN UPDATE serialnumbers    SET remainActiveCount = remainActiveCount - 1    WHERE number =@number;INSERT INTO activerecord (number, mac, addTime, state)VALUES    (@number ,@mac, now(), 0);SELECT    0;ENDELSEBEGIN    SELECT 1;END';
    var newSql = sql.replace(/@number/gi, mysql.escape(key)).replace(/@mac/gi, mac);
    return newSql;
}