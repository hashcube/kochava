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

  this.trackPurchase = function (receipt, item, revenue,
    currency, transaction_id) {
    pluginSend('trackPurchase', {
      receipt: receipt,
      transactionId: transaction_id,
      productId: item,
      revenue: revenue,
      currency: currency
    });
  };

  this.trackEventWithValue = function (event_name, value) {
    var params = {
      event_name: event_name,
      value: value
    };
    pluginSend('trackEventWithValue', params);
  };

});

exports = new Kochava();
