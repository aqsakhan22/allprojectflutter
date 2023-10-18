// Initialzation

const express = require('express');

const app = express();
const db = require('mongoose');
const jwt = require('jsonwebtoken');
const bodyPaser=require('body-parser');


app.use(bodyPaser.urlencoded({extended:false})); // we use app.use for to puts the specified middleware functions at the specified path
// if we use nested objects we have to keep this params true other wise false 
app.use(bodyPaser.json());

// Express body-parser is an npm module used to process data sent in an HTTP request body.
//  It provides four express middleware for parsing JSON, Text, URL-encoded, and raw data sets over an HTTP request body. 
//  Before the target controller receives an incoming request, these middleware routines handle it.


db.connect("mongodb+srv://aqsakhan19966:aqsakhan1234@cluster0.dfgssqj.mongodb.net/notesdb").then(function(){
    console.log("conneted to mongoose");

    //Authorization checking
    // app.use((req, res, next) => {
    //     console.log("req method is ",req.headers.authorization);

    //     // res.header("Access-Control-Allow-Origin", "*",);
       
    //     // res.header(
    //     //   "Access-Control-Allow-Headers",
    //     //   "Origin, X-Requested-With, Content-Type, Accept, Authorization"
    //     // );
    //     // if (req.method === "OPTIONS") {
            
    //     //   res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
    //     //   return res.status(200).json({});
    //     // }
    //     if(req.headers.authorization != "Basic abced"){
    //         return res.json({'message':"Unauthoprized"});
            

    //     }
    //     next();
       
    //   });
// App Routes
//      app.get('/',function (req,res){
//        res.header('Content-type', 'text/html');
//         return res.send('<h2>I said "Oh my!" What a marvelous tune!!!</h2>');
//     // res.send('This is the Home Page');
//     // const response={message:"Api works"};
//     //     res.json(response);
//    });


   app.get('/login',function (req,res){
    console.log('login api hits');
         const user={id:1,name:'aqsa khan'};
      const token=jwt.sign({user},'secret_key');
      console.log('token is',token);
      res.json({'token':token})
     });

     app.get('/protected',function (req,res){
        console.log('protected',);
            jwt.verify(req.headers.authorization,'secret_key',function(err,data){
                if(err){
                  res.sendStatus(403);
                }
                else{
                    res.json({
                        text:'this is a protected',
                        data:data
                    });
                }
            });
         });
    
   const notesRouter=require('./routes/Routes');
//    app.use('/notes',notesRouter); // example /notes/list 
app.use('/notes',notesRouter); 


});

// module.exports = app;
// module.exports.handler = serverless(app);
const PORT=process.env.PORT || 3000;

app.listen(PORT);