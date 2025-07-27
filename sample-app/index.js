const express = require('express');
const AWS = require('aws-sdk');
const app = express();
const port = 3000;

const s3 = new AWS.S3({ region: 'us-east-1' });

app.get('/', async (req, res) => {
    res.status(200).send("OK");
});

app.get('/s3/write', async (req, res) => {
    const name = req.query.name || 'default.txt';
    const content = req.query.content || 'Hello from default content';

    try {
        await s3.putObject({
            Bucket: process.env.S3_BUCKET,
            Key: name,
            Body: content
        }).promise();

        res.send(`File "${name}" written to S3 with content: "${content}"`);
    } catch (err) {
        console.error(err);
        res.status(500).send('S3 write failed');
    }
});

app.listen(port, () => console.log(`App listening on port ${port}`));

