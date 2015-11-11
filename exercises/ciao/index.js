var express = require('express');

// Constants
var PORT = (process.env.PORT || "5000");
var MESSAGE = (process.env.MESSAGE || "Ciao mondo!");

// SIGINT handler
process.on('SIGINT', function() {
  console.log("Caught interrupt signal");
  process.exit();
});

// App
var app = express();
app.get('/', function (req, res) {
  res.send(MESSAGE + '\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
