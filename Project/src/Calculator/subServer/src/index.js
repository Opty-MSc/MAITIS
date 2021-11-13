const express = require("express");
const app = express();
const apiMetrics = require('prometheus-api-metrics');

app.use(apiMetrics());

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    next();
})

app.get("/sub", (req, res) => {
    const r = parseFloat(req.query['X']) - parseFloat(req.query['Y']);
    console.log(`${req.query['X']} - ${req.query['Y']} = ${r}`);
    res.send({r});
});

const port = 8090;
app.listen(port, () => {
    console.log(`Started at http://10.0.1.52:${port}`);
});
