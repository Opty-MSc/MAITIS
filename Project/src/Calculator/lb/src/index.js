const express = require("express");
const axios = require("axios")
const app = express();
const apiMetrics = require('prometheus-api-metrics');

app.use(apiMetrics());

const endpoints = {
    add: "http://10.0.1.51:8090/add",
    sub: "http://10.0.1.52:8090/sub",
    mul: "http://10.0.1.53:8090/mul",
    div: "http://10.0.1.54:8090/div"
}

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    next();
})

app.get("/", async (req, res) => {
    const endpoint = `${endpoints[req.query['OP']]}?X=${req.query['X']}&Y=${req.query['Y']}`
    res.send((await axios.get(endpoint)).data);
});

const port = 8090;
app.listen(port, () => {
    console.log(`Started at port ${port}`);
});
