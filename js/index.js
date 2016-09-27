/* global Class, exports:true, NATIVE */

function pluginSend(evt, params) {
  'use strict';

  NATIVE.plugins.sendEvent('KochavaPlugin', evt,
    JSON.stringify(params || {}));
}

var Kochava = Class(function () {
  'use strict';

  this.init = function () {};

  this.setUserId = function (uid) {
    // Allowed params
    // uid : custom user id
    pluginSend('setUserId', {
      uid: uid
    });
  };

  this.trackPurchase = function (uid, receipt, item, revenue,
    currency, transaction_id) {
    pluginSend('trackPurchase', {
      uid: uid,
      receipt: receipt,
      transactionId: transaction_id,
      productId: item,
      revenue: revenue,
      currency: currency
    });
  };
});

exports = new Kochava();
