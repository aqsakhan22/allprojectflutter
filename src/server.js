// Initialzation

const express = require('express');

const app = express();
const db = require('mongoose');
const bodyPaser=require('body-parser');

app.use(bodyPaser.urlencoded({extended:false})); // we use app.use for to puts the specified middleware functions at the specified path
// if we use nested objects we have to keep this params true other wise false 
app.use(bodyPaser.json());
// Express body-parser is an npm module used to process data sent in an HTTP request body.
//  It provides four express middleware for parsing JSON, Text, URL-encoded, and raw data sets over an HTTP request body. 
//  Before the target controller receives an incoming request, these middleware routines handle it.


db.connect("mongodb+srv://aqsakhan19966:aqsakhan1234@cluster0.dfgssqj.mongodb.net/notesdb").then(function(){
    console.log("conneted to mongoose");

// App Routes
     app.get('/',function (req,res){

    res.send('This is the Home Page');
    const response={message:"Api works"};
        res.json(response);
   });
    
   const notesRouter=require('./routes/Routes');
   app.use('/notes',notesRouter); // example /notes/list 


});
const PORT=process.env.PORT || 3000;

app.listen(PORT);