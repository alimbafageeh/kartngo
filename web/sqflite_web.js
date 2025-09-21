// sqflite_web.js

// This script registers the sqflite web worker.
if (typeof self.importScripts === 'function') {
  self.importScripts('sqflite_web_worker.js');
}
