// sqflite_web_worker.js

console.log("sqflite web worker loaded");

// This is a stub worker. In practice, sqflite_common_ffi_web
// will handle the DB logic here, but you need the file
// present so the worker can start without 404.
self.onmessage = function (event) {
  console.log("sqflite worker received:", event.data);
};
