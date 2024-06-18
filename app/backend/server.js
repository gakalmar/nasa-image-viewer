const express = require('express');
const path = require('path');

const app = express();

const staticFolder = path.join(__dirname, '..', 'frontend');
app.use(express.static(staticFolder));

app.listen(3000, () => {
		console.log('http://localhost:3000');
});
